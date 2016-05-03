/*

	Written by Andrus Aaslaid, ES1UVB
	andrus.aaslaid(6)gmail.com

	http://uvb-76.net

	This source code is licensed as Creative Commons Attribution-ShareAlike
	(CC BY-SA). 
	
	From http://creativecommons.org:

		This license lets others remix, tweak, and build upon your work even for commercial purposes, as long as they 
		credit you and license their new creations under the identical terms. This license is often compared to 
		“copyleft” free and open source software licenses. All new works based on yours will carry the same license, 
		so any derivatives will also allow commercial use. This is the license used by Wikipedia, and is recommended 
		for materials that would benefit from incorporating content from Wikipedia and similarly licensed projects. 


	This DLL provides an empty core for implementing hardware support functionality
	for the Winrad Software Defined Radio (SDR) application, created by Jeffrey Pawlan (WA6KBL)
	(www.winrad.org) and its offsprings supporting the same ExtIO DLL format,
	most notably the outstanding HDSDR software (hdsdr.org)

	As the Winrad source is written on Borland C-Builder environment, there has been very little 
	information available of how the ExtIO DLL should be implemented on Microsoft Visual Studio 2008
	(VC2008) environment and the likes. 

	This example is filling this gap, providing the empty core what can be compiled as appropriate 
	DLL working for HDSDR

	Note, that Winrad and HDSDR are sometimes picky about the DLL filename. The ExtIO_blaah.dll for example,
	works, while ExtIODll.dll does not. I havent been digging into depths of that. It is just that if your
	custom DLL refuses to be recognized by application for no apparent reason, trying to change the DLL filename
	may be a good idea.

	To have the DLL built with certain name can be achieved changing the LIBRARY directive inside ExtIODll.def


	Revision History:

	30.05.2011	-	Initial 
	22.04.2012	-	Cleaned up for public release

*/

#include "ExtIOFunctions.h"

#include <windows.h>
#include <stdio.h>
#include <math.h>
#include <winsock.h>
#pragma comment (lib, "wsock32.lib")
#include <stdexcept>

using namespace std;

#define OSC_FREQ 20000000

int frequency = 5000000;
short iq_data[1024];

void (* ExtIOCallback)(int, int, float, void *) = NULL;

HANDLE TriggerEvent;//HANDLE обработчика
HANDLE hTimer = NULL;
HANDLE hTimerQueue = NULL;
bool timer_started = false;

float t=0;

HANDLE hThread;
HANDLE hPort=NULL;
DWORD dwError;

int Init(char* lpszPortName)
{
	//DWORD dwThreadID;
	DCB PortDCB;
	COMMTIMEOUTS CommTimeouts;

	dwError=0;

	// Open the serial port.
	hPort = CreateFile (lpszPortName, // Pointer to the name of the port
                      GENERIC_READ | GENERIC_WRITE,
                                    // Access (read/write) mode
                      0,            // Share mode
                      NULL,         // Pointer to the security attribute
                      OPEN_EXISTING,// How to open the serial port
                      0, //FILE_FLAG_OVERLAPPED, // Port attributes
                      NULL);        // Handle to port with attribute
                                    // to copy

	// If it fails to open the port, return FALSE.
	if ( hPort == INVALID_HANDLE_VALUE ) 
	{
		// Could not open the port.
		dwError = GetLastError ();
		//MessageBox (NULL, TEXT("Unable to open the port specified..."),TEXT("Error"), MB_OK);
		return dwError;
	}

	PortDCB.DCBlength = sizeof (DCB);     

	// Get the default port setting information.
	GetCommState (hPort, &PortDCB);

	// Change the DCB structure settings.
	PortDCB.BaudRate = 12000000;         // Current baud 
	PortDCB.fBinary = TRUE;               // Binary mode; no EOF check 
	PortDCB.fParity = TRUE;               // Enable parity checking. 
	PortDCB.fOutxCtsFlow = FALSE;         // No CTS output flow control 
	PortDCB.fOutxDsrFlow = FALSE;         // No DSR output flow control 
	PortDCB.fDtrControl = DTR_CONTROL_DISABLE; 
										// DTR flow control type 
	PortDCB.fDsrSensitivity = FALSE;      // DSR sensitivity 
	PortDCB.fTXContinueOnXoff = TRUE;     // XOFF continues Tx 
	PortDCB.fOutX = FALSE;                // No XON/XOFF out flow control 
	PortDCB.fInX = FALSE;                 // No XON/XOFF in flow control 
	PortDCB.fErrorChar = FALSE;           // Disable error replacement. 
	PortDCB.fNull = FALSE;                // Disable null stripping. 
	PortDCB.fRtsControl = RTS_CONTROL_DISABLE; 
										// RTS flow control 
	PortDCB.fAbortOnError = FALSE;        // Do not abort reads/writes on 
										// error.
	PortDCB.ByteSize = 8;                 // Number of bits/bytes, 4-8 
	PortDCB.Parity = NOPARITY;            // 0-4=no,odd,even,mark,space 
	PortDCB.StopBits = ONESTOPBIT;        // 0,1,2 = 1, 1.5, 2 

	// Configure the port according to the specifications of the DCB 
	// structure.
	if (!SetCommState (hPort, &PortDCB))
	{
		// Could not configure the serial port.
    
		dwError = GetLastError ();
		//MessageBox (NULL, TEXT("Unable to configure the serial port"), TEXT("Error"), MB_OK);
		return dwError;
	}

	// Retrieve the time-out parameters for all read and write operations
	// on the port. 
	GetCommTimeouts (hPort, &CommTimeouts);

	// Change the COMMTIMEOUTS structure settings.
	CommTimeouts.ReadIntervalTimeout = MAXDWORD;  
	CommTimeouts.ReadTotalTimeoutMultiplier = 0;  
	CommTimeouts.ReadTotalTimeoutConstant = 0;    
	CommTimeouts.WriteTotalTimeoutMultiplier = 10;  
	CommTimeouts.WriteTotalTimeoutConstant = 1000;    

	// Set the time-out parameters for all read and write operations
	// on the port. 
	if (!SetCommTimeouts (hPort, &CommTimeouts))
	{
		// Could not set the time-out parameters.
    
		dwError = GetLastError ();
		//MessageBox (NULL, TEXT("Unable to set the time-out parameters"), TEXT("Error"), MB_OK);
		return dwError;
	}

	// Direct the port to perform extended functions SETDTR and SETRTS.
	// SETDTR: Sends the DTR (data-terminal-ready) signal.
	// SETRTS: Sends the RTS (request-to-send) signal. 
	EscapeCommFunction (hPort, SETDTR);
	EscapeCommFunction (hPort, SETRTS);
	return 0;
}

ULONG __stdcall ThreadStart(void* lParam)
{
	unsigned char buffer[4096*2];
	unsigned char pkt[512*8];
	char str[256];
	DWORD sz = 512*10;
	DWORD got=0;
	DWORD idx;
	BOOL err_num=0;
	
	//drop all accumulated data in serial port buffers
	PurgeComm(hPort, PURGE_RXABORT|PURGE_TXABORT|PURGE_RXCLEAR|PURGE_TXCLEAR);
	int num_blocks=0;
	while(1)
	{
		//data is sent by 10-byte packets, find 1st byte in packet
		//first byte in packet has 7th bit set, other bytes have 7th bit reset
		while(1)
		{
			got=0;
			if( !ReadFile(hPort,buffer,1,&got,NULL) )
			{
				sprintf_s(str,sizeof(str),"Error read COM port: %08X\n",GetLastError());
				OutputDebugString(str);
				return -1;
			}
		
			if( got==1 )
			{
				if( buffer[0]&0x80 )
				{
					//ok, first byte in packet was found
					break; 
				}
			}
			else
			{
				Sleep(10);
				continue;
			}
		}
		idx=1;
		bool protocol_err=false;
		DWORD ticks=0;
		while(1)
		{
			//read whole block
			got=0;
			if( !ReadFile(hPort,&buffer[idx],sz-idx,&got,NULL) )
			{
				sprintf_s(str,sizeof(str),"Error read COM port: %08X\n",GetLastError());
				OutputDebugString(str);
				return -1;
			}
			idx+=got;
			if(idx!=sz) continue;

			idx=0;
			//repack
			for(int i=0; i<512; i++)
			{
				protocol_err=false;
				if((buffer[i*10+0]&0x80)==0) protocol_err=true;
				if( buffer[i*10+1]&0x80) protocol_err=true;
				if( buffer[i*10+2]&0x80) protocol_err=true;
				if( buffer[i*10+3]&0x80) protocol_err=true;
				if( buffer[i*10+4]&0x80) protocol_err=true;
				if(protocol_err)
				{
					err_num++;
					sprintf_s(str,sizeof(str),"Err: %d %d\n",i,err_num);
					OutputDebugString(str);
					printf(str);
					break;
				}
				//reconstruct received 10 bytes packets into 2 integer pairs of I/Q values
				//1st channel
				pkt[i*8+0]=buffer[i*10+1] | ((buffer[i*10+0]&1) ? 0x80 : 0 );
				pkt[i*8+1]=buffer[i*10+2] | ((buffer[i*10+0]&2) ? 0x80 : 0 );
				pkt[i*8+2]=buffer[i*10+3] | ((buffer[i*10+0]&4) ? 0x80 : 0 );
				pkt[i*8+3]=buffer[i*10+4] | ((buffer[i*10+0]&8) ? 0x80 : 0 );
				//2nd channel
				pkt[i*8+4]=buffer[i*10+6] | ((buffer[i*10+5]&1) ? 0x80 : 0 );
				pkt[i*8+5]=buffer[i*10+7] | ((buffer[i*10+5]&2) ? 0x80 : 0 );
				pkt[i*8+6]=buffer[i*10+8] | ((buffer[i*10+5]&4) ? 0x80 : 0 );
				pkt[i*8+7]=buffer[i*10+9] | ((buffer[i*10+5]&8) ? 0x80 : 0 );
			}
			if(protocol_err) break;
			(*ExtIOCallback)(512, 0, 0, pkt);
			num_blocks++;
			DWORD ticks2=GetTickCount();
			if(ticks2-ticks>1000)
			{
				ticks=ticks2;
				printf("%d Blocks/Sec\n",num_blocks);
				num_blocks=0;
			}
		}
	}
return 0;
}

void send_freq(int frequency)
{
	unsigned char pkt[5];

	int freq = frequency * 0x100000000 / OSC_FREQ;
	
	pkt[0] = 0x80;
	pkt[1] = (freq >> 0 ) & 0xFF;
	pkt[2] = (freq >> 8 ) & 0xFF;
	pkt[3] = (freq >> 16) & 0xFF;
	pkt[4] = (freq >> 24) & 0xFF;
	
	if(pkt[1]&0x80) pkt[0] |= 1;
	if(pkt[2]&0x80) pkt[0] |= 2;
	if(pkt[3]&0x80) pkt[0] |= 4;
	if(pkt[4]&0x80) pkt[0] |= 8;

	pkt[1]=pkt[1]&0x7F;
	pkt[2]=pkt[2]&0x7F;
	pkt[3]=pkt[3]&0x7F;
	pkt[4]=pkt[4]&0x7F;

	DWORD wr=0;
	WriteFile( hPort, pkt, sizeof(pkt), &wr, NULL);
}

//called once at startup time
extern "C" bool __stdcall InitHW(char *name, char *model, int& type)
{
	type = 6;	//the hardware does its own digitization and the audio data are returned to Winrad
				//via the callback device. Data must be in 32‐bit  (int) format, little endian.
	char* my_sdr_name  = "SDR M2 FPGA";
	char* my_sdr_model = "SDR M2 v1.0";
	memcpy(name, my_sdr_name, strlen(my_sdr_name)+1);
	memcpy(model,my_sdr_model,strlen(my_sdr_name)+1);

	Init( "\\.\\COM6" );
	return true;
}

extern "C" bool __stdcall OpenHW(void)
{
	AllocConsole() ;
	AttachConsole( GetCurrentProcessId() ) ;
	freopen( "CON", "w", stdout ) ;
	printf("Hello SDR!\n");
	return true;
}

extern "C" int __stdcall StartHW(long freq)
{
	DWORD dwID=0;
	if( hPort!=NULL && hPort!=INVALID_HANDLE_VALUE )
		hThread=CreateThread(0,64*1024,&ThreadStart,NULL,0,&dwID);

	return 512;	// number of complex elements returned each
				// invocation of the callback routine
}

extern "C" void __stdcall StopHW(void)
{
	TerminateThread(hThread,0);
	return; // nothing to do with this specific HW
}

extern "C" void __stdcall CloseHW(void)
{
	return; // nothing to do with this specific HW
}

extern "C" int __stdcall SetHWLO(long LOfreq)
{	
	frequency = (int)LOfreq;
	char buffer[512];
	sprintf_s(buffer,sizeof(buffer),"Freq=%d\n", frequency);
	OutputDebugString(buffer);
	send_freq(frequency);
	return 0; // return 0 if the frequency is within the limits the HW can generate
}

extern "C" long __stdcall GetHWLO(void)
{
	return (long)frequency;	//LOfreq;
}

extern "C" long __stdcall GetHWSR(void)
{
	return 50000;
}

extern "C" long __stdcall GetTune(void)
{
	return (long)frequency;
}

extern "C" int __stdcall GetStatus(void)
{
	return 0;
}

extern "C" void __stdcall TuneChanged(long freq)
{
	return;
}

extern "C" void __stdcall SetCallback(void (* Callback)(int, int, float, void *))
{
	ExtIOCallback = Callback;
	(*ExtIOCallback)(-1, 101, 0, NULL);			// sync lo frequency on display
	(*ExtIOCallback)(-1, 105, 0, NULL);			// sync tune frequency on display

		return;		// this HW does not return audio data through the callback device
					// nor it has the need to signal a new sampling rate.
}

extern "C" void __stdcall RawDataReady(long samprate, int *Ldata, int *Rdata, int numsamples)
{
	return;
}


