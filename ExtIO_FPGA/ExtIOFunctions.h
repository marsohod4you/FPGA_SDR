
#if !defined(AFX_EXTIOCLASS_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_)
#define AFX_EXTIOCLASS_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

	extern "C" __declspec(dllexport) bool __stdcall InitHW(char *name, char *model, int& type);
	extern "C" __declspec(dllexport) bool __stdcall OpenHW(void);
	extern "C" __declspec(dllexport) int __stdcall StartHW(long freq);
	extern "C" __declspec(dllexport) void __stdcall StopHW(void);
	extern "C" __declspec(dllexport) void __stdcall CloseHW(void);
	extern "C" __declspec(dllexport) int __stdcall SetHWLO(long LOfreq);
	extern "C" __declspec(dllexport) long __stdcall GetHWLO(void);
	extern "C" __declspec(dllexport) long __stdcall GetHWSR(void);
	extern "C" __declspec(dllexport) long __stdcall GetTune(void);
	extern "C" __declspec(dllexport) void __stdcall GetFilters(int& loCut, int& hiCut, int& pitch);
	//extern "C" __declspec(dllexport) char __stdcall GetMode(void);
	//extern "C" __declspec(dllexport) void __stdcall ModeChanged(char mode);
	extern "C" __declspec(dllexport) int __stdcall GetStatus(void);
	//extern "C" __declspec(dllexport) void __stdcall ShowGUI(void);
	//extern "C" __declspec(dllexport) void __stdcall HideGUI(void);
	//extern "C" __declspec(dllexport) void __stdcall IFLimitsChanged(long low, long high);
	extern "C" __declspec(dllexport) void __stdcall TuneChanged(long freq);
	//extern "C" __declspec(dllexport) void __stdcall FiltersChanged(int loCut, int hiCut, int pitch, bool mute);
	extern "C" __declspec(dllexport) void __stdcall SetCallback(void (* Callback)(int, int, float, void *));
	extern "C" __declspec(dllexport) void __stdcall RawDataReady(long samprate, int *Ldata, int *Rdata, int numsamples);

	void create_timer(void);
	void destruct_timer(void);

#endif // !defined(AFX_EXTIOCLASS_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_)
