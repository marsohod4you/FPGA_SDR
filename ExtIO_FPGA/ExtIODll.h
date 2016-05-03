// ExtIODll.h : main header file for the MYDLL DLL
//

#if !defined(AFX_EXTIODLL_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_)
#define AFX_EXTIODLL_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMyDllApp
// See MyDll.cpp for the implementation of this class
//

class CExtIODllApp : public CWinApp
{
public:
	CExtIODllApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMyDllApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CMyDllApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXTIODLL_H__247C1094_0293_40d5_846A_6CC900C82E80__INCLUDED_)
