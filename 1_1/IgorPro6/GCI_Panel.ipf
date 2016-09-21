#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Version 0.93
//
// Requires the EasyHttp XOP installed
//
// MIT License
//
// Copyright (c) 2016 John Sader and Jason Kilpatrick
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software. The name "Sader Method - Global
// Calibration Initiative" or the equivalent "Sader Method GCI" and its URL 
// "sadermethod.org" shall be listed prominently in the title of any future 
// realization/modification of this software and its rendering in any AFM software
// or other platform, as it does in the header of this software and its rendering. 
// Reference to this software by any third party software or platform shall include
// the name "Sader Method - Global Calibration Initiative" or the equivalent "Sader
// Method GCI" and its URL "sadermethod.org".
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

////////////////////////////////////////////////////////////////////////////////////////////// 
////////          			Constants          													///////// 
/////////////////////////////////////////////////////////////////////////////////////////////

	static strconstant Version			=	"V0.93"
 
	static strconstant cUVW             =	"root:packages:MFP3D:Main:Variables:UserVariablesWave" 
	static strconstant cUVD             =	"root:packages:MFP3D:Main:Variables:UserVariablesDescription" 
 
	static strconstant cMVW             =	"root:Packages:MFP3D:Main:Variables:MasterVariablesWave"
	static strconstant cTVW             =	"root:Packages:MFP3D:Main:Variables:ThermalVariablesWave"

	static strconstant cUname          	=	"root:packages:GCI:Uname"
	static strconstant cPWDtemp      	=	"root:packages:GCI:PWDtemp"
	static strconstant cPWD          	=	"root:packages:GCI:PWD"
	static strconstant cOutput         	=	"root:packages:GCI:Output"
	static strconstant cLID				=	"root:packages:GCI:LeverIDs"
	static strconstant cLN         		=	"root:packages:GCI:LeverNames"
	static strconstant cStatus			=	"root:packages:GCI:Status"
 
////////////////////////////////////////////////////////////////////////////////////////////// 
////////       				Menu Entries           											///////// 
///////////////////////////////////////////////////////////////////////////////////////////// 
 
Menu "Sader Method GCI" 
	"GCI Panel",/Q, MakeGCIPanel() 
End
 
Menu "P&rogramming" 
	SubMenu "Global Variables" 
		"GCI Parms",/Q, MakeVariableTable("User") 
	End 
End 
 
////////////////////////////////////////////////////////////////////////////////////////////// 
////////                Parameter Initialization        									///////// 
///////////////////////////////////////////////////////////////////////////////////////////// 
 
 
Function GCI_Init()    // Adds Missing Parameters to UserVariablesWave 
 
	String ParmList = "" 
	String DescList = ""      
	String UnitsList = "" 
	String FormatList = "" 
   
	Wave Var = $cUVW 
	Wave MVW = $cMVW 
   
	ParmList    +=	"GCI_Freq;GCI_Qf;GCI_Thermalk;GCI_SaderK;GCI_SaderKerr;"
	ParmList    +=	"GCI_AValue;GCI_AValueErr;GCI_LeverID;GCI_Samples;GCI_UploadK;"
	ParmList    +=	"GCI_Loggedin;GCI_Error;GCI_DataUploaded;"
	DescList    +=	"Fit Frequency;Fit Q;Themal k (from fit);SaderK;SaderK Error %;"
	DescList    +=	"A value;A value Error;Lever ID;Number of Samples;Include ThermalK;"
	DescList    +=	"Login Successful;Error in Transaction;Data Uploaded;"
	UnitsList   +=	"Hz;;N/m;N/m;%;;;;;;;;;" 
	FormatList  +=	""
   
	variable i 
	String Parm 
   
	for (i = 0; i < itemsinlist(ParmList); i += 1) 
		Parm = stringfromlist(i,ParmList) 
		ARAddParm(Parm,"UserVariablesWave","") 
		PDS(Parm,stringfromlist(i,DescList)) 
		PUS(Parm,stringfromlist(i,UnitsList)) 
	endfor 
  
	NewDataFolder/O root:packages:GCI
 
	String/G root:packages:GCI:Uname 			=	""
	String/G root:packages:GCI:PWDtemp			=	""
	String/G root:packages:GCI:PWD				=	""
	String/G root:packages:GCI:LeverIDs			=	""
	String/G root:packages:GCI:LeverNames 		=	""
	String/G root:packages:GCI:Output			=	""
	String/G root:packages:GCI:Status			=	""
  
	Var[%GCI_Loggedin][0]		= 0
	Var[%GCI_Error][0]			= 0
	Var[%GCI_DataUploaded][0]	= 0
	Var[%GCI_LeverID][0]		= 0
	
	Var[%GCI_SaderK][0] 		= 0
	Var[%GCI_SaderKerr][0] 	= 0
	Var[%GCI_AValue][0] 		= 0
	Var[%GCI_AValueErr][0] 	= 0
	Var[%GCI_Samples][0]		= 0
	
	if (MVW[%AmpInvOLS][0] > 1.089e-07 && MVW[%AmpInvOLS][0] < 1.091e-07)
		Var[%GCI_UploadK][0] = 0
	else
		Var[%GCI_UploadK][0] = 1
	endif
	
End  // GCI_Init 

Function MakeGCIPanel() : Panel

	Dowindow/F GCIPanel

	if (v_flag)
		return 0
	endif

	GCI_Init()

	Wave Var = $cUVW 
	SVAR Status = $cStatus

	PauseUpdate; Silent 1		// building window...
	NewPanel/K=1/W=(421,60,739,608)/N=GCIPanel as "Sader Method GCI "+Version
	ModifyPanel frameStyle=1

	SetDrawLayer UserBack
	DrawText 40,24,"Sader Method - Global Calibration Initiative"
	DrawText 105,40,"sadermethod.org"
	SetDrawEnv fsize= 10
	DrawText 22,416,"Please register at sadermethod.org before using this panel"
	SetDrawEnv fsize= 10
	DrawText 70,373,"Need to add a cantilever to the list?"
	SetDrawEnv fname= "MS Sans Serif"
	DrawText 271,142,"Enable"

	SetVariable GCI_UserName,pos={53,56},size={207,16},bodyWidth=150,proc=GCI_SetVarProc,title="User Name",win=GCIPanel
	SetVariable GCI_UserName,value= root:packages:GCI:Uname,win=GCIPanel
	SetVariable GCI_Password,pos={60,76},size={200,16},bodyWidth=150,proc=GCI_SetVarProc,title="Password",win=GCIPanel
	SetVariable GCI_Password,value= root:packages:GCI:PWDtemp,win=GCIPanel
	SetVariable GCI_Freq,pos={50,106},size={210,16},bodyWidth=115,title="Thermal Frequency",win=GCIPanel
	SetVariable GCI_Freq,format="%.3W1PHz",win=GCIPanel
	SetVariable GCI_Freq,limits={0,inf,1},value= root:packages:MFP3D:Main:Variables:ThermalVariablesWave[%ThermalFrequency][%Value],win=GCIPanel
	SetVariable GCI_QF,pos={35,126},size={225,16},bodyWidth=115,title="Thermal Quality Factor",win=GCIPanel
	SetVariable GCI_QF,format="%.1W1P",win=GCIPanel
	SetVariable GCI_QF,limits={0,inf,1},value= root:packages:MFP3D:Main:Variables:ThermalVariablesWave[%ThermalQ][%Value],win=GCIPanel
	SetVariable GCI_ThermalK,pos={25,148},size={235,16},bodyWidth=115,title="Thermal Spring Constant",win=GCIPanel
	SetVariable GCI_ThermalK,format="%.3W1PN/m",win=GCIPanel
	SetVariable GCI_ThermalK,limits={0,inf,1},value= root:packages:MFP3D:Main:Variables:MasterVariablesWave[%SpringConstant][%Value],win=GCIPanel
	SetVariable GCI_SaderK,pos={46,279},size={210,16},bodyWidth=100,title="Sader Spring Constant",win=GCIPanel
	SetVariable GCI_SaderK,format="%.2W1PN/m",win=GCIPanel
	SetVariable GCI_SaderK,limits={0,inf,0},value= root:packages:MFP3D:Main:Variables:UserVariablesWave[%GCI_SaderK][%Value],win=GCIPanel
	SetVariable GCI_SaderKerr,pos={40,302},size={216,16},bodyWidth=100,title="Error estimate (95% C.I.)",win=GCIPanel
	SetVariable GCI_SaderKerr,format="%.2f %",win=GCIPanel
	SetVariable GCI_SaderKerr,limits={0,inf,0},value= root:packages:MFP3D:Main:Variables:UserVariablesWave[%GCI_SaderKerr][%Value],win=GCIPanel
	SetVariable GCI_Samples,pos={60,324},size={196,16},bodyWidth=100,title="Number of Samples",win=GCIPanel
	SetVariable GCI_Samples,help={"Number of Samples in the CGI Database"},win=GCIPanel
	SetVariable GCI_Samples,limits={0,inf,0},value= root:packages:MFP3D:Main:Variables:UserVariablesWave[%GCI_Samples][%Value],win=GCIPanel

	PopupMenu GCI_LeversPopup,pos={13,178},size={280,22},bodyWidth=250,disable=2,proc=GCI_PopMenuProc,title="Lever",win=GCIPanel
	PopupMenu GCI_LeversPopup,fSize=10,win=GCIPanel
	PopupMenu GCI_LeversPopup,mode=11,popvalue="Please Select...",value= #"root:packages:GCI:LeverNames",win=GCIPanel

	Button GCI_RegisterButton,pos={78,422},size={150,20},proc=GCI_ButtonProc,title="Click here to register",win=GCIPanel
	Button GCI_Upload,pos={83,216},size={150,40},proc=GCI_ButtonProc,title="Upload Data",win=GCIPanel
	Button GCI_Upload,fColor=(61440,61440,61440),win=GCIPanel
	Button GCI_RequestButton,pos={78,377},size={150,20},proc=GCI_ButtonProc,title="Click here to request a lever",win=GCIPanel
	
	CheckBox GCI_UploadK,pos={280,149},size={16,14},proc=GCI_CheckProc,title="",win=GCIPanel
	CheckBox GCI_UploadK,help={"Include Thermal K in Upload?"},value=Var[%GCI_UploadK][0],win=GCIPanel

	GroupBox CGI_StatusBox,pos={7,451},size={305,85},title="Status",win=GCIPanel
	GroupBox CGI_StatusBox,labelBack=(65535,65535,65535),frame=0,win=GCIPanel

	TitleBox GCI_StatusText,pos={10,465},size={295,62},frame=0,variable=Status,win=GCIPanel

	GCI_Status()
	
End

Function GCI_SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	SVAR PW = $cPWD
	SVAR PWtemp = $cPWDtemp
	
	//obfuscate password
	if (stringmatch(ctrlName,"GCI_Password"))
		PW = varStr
		PWtemp = Padstring("",strlen(varStr),0x2a)
		GCI_RequestLeverList()
	endif
	
	GCI_Status()

End

Function GCI_ButtonProc(ctrlName) : ButtonControl
	String ctrlName
	
	if (stringmatch(ctrlName, "*register*"))
		BrowseURL "https://sadermethod.org/register.php"
	elseif (stringmatch(ctrlName, "*request*"))
		BrowseURL "https://sadermethod.org/Main/suggest.php"
	else
		GCI_RequestData()
	endif
	
	GCI_Status()

End

Function GCI_PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Wave Var 			= $cUVW
	SVAR LeverIDs	= $cLID
	
	Var[%GCI_LeverID][0] = GetEndNum(stringfromlist(popNum-1,LeverIDs))
	
	GCI_Status()

End

Function GCI_RequestLeverList()

	Wave Var 			= $cUVW
	SVAR Output		= $cOutput
	SVAR LeverIDs	= $cLID
	SVAR LeverNames	= $cLN
	SVAR Uname		= $cUname
	SVAR PWDtemp		= $cPWDtemp

	String Request = CGI_RequestLeverListStr()

	easyHttp /POST=Request "http://sadermethod.org/api/1.1/api.php", Output
		
	if (GCI_ErrorCheck(v_flag) == 0)
		LeverIDs = GCI_GetList("id")
		LeverNames = GCI_GetList("label")
	else
		Uname = ""
		PWDtemp = ""
	endif

	GCI_Status()
	
End

Function GCI_RequestData()

	Wave Var 			= $cUVW
	SVAR Output		= $cOutput
		
	if (Var[%GCI_LeverID][0] != 0)

		String Request = CGI_RequestDataStr()
	
		easyHttp /POST=Request "http://sadermethod.org/api/1.1/api.php", Output
		
		if (GCI_ErrorCheck(v_flag) == 0)
			GCI_UpdateTable()
		endif
		
	else
	
		DoAlert 0, "Error: Please select a lever."
		
	endif
	
	GCI_Status()
	
End

	
Function/S CGI_RequestLeverListStr()
	
	SVAR UserName = $cUname
	SVAR Password = $cPWD

	String Request = ""

	Request += "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r"
	Request += "<saderrequest>\r"
	Request += "  <username>"+UserName+"</username>\r"
	Request += "  <password>"+Password+"</password>\r"
	Request += "  <operation>LIST</operation>\r"
	Request += "</saderrequest>"

	return Request	

End

Function/S CGI_RequestDataStr()
	
	Wave Var 			= $cUVW
	Wave MVW			= $cMVW
	SVAR UserName 	= $cUname
	SVAR Password 	= $cPWD
	
	GCI_CopyParms()

	String Request = ""

	Request += "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r"
	Request += "<saderrequest>\r"
	Request += "  <username>"+UserName+"</username>\r"
	Request += "  <password>"+Password+"</password>\r"
	Request += "  <operation>UPLOAD</operation>\r"
	Request += "  <cantilever>\r"
	Request += "    <id>data_"+num2str(Var[%GCI_LeverID][0])+"</id>\r"
	Request += "    <frequency>"+num2str(Var[%GCI_Freq][0]/1000)+"</frequency>\r"
	Request += "    <quality>"+num2str(Var[%GCI_QF][0])+"</quality>\r"
	if (Var[%GCI_UploadK][0])
		Request += "    <constant>"+num2str(Var[%GCI_Thermalk][0])+"</constant>\r"
		Request += "    <comment>Asylum API "+Version+"</comment>\r"
	endif
	Request += "  </cantilever>\r"
	Request += "</saderrequest>"

	return Request
	
End

Function/S GCI_GetString(name)
	string name

	SVAR Output = $cOutput
	
	string temp = ""
	
	temp = GrepList(Output, "<"+name+">.*</"+name+">",0,"\n")
	temp = temp[strsearch(temp,"<",0),strsearch(temp,">",Inf,1)]
	temp = replacestring("<"+name+">",temp,"")
	temp = replacestring("</"+name+">",temp,"")
	
	return temp
	
End

Function GCI_GetValue(name)
	string name

	return str2num(GCI_GetString(name))
	
End

Function/S GCI_GetList(name)
	string name

	SVAR Output = $cOutput
	
	string temp = ""
	
	temp = GrepList(Output, "<"+name+">.*</"+name+">",0,"\n")
	temp = temp[strsearch(temp,"<",0),Inf]
	temp = replacestring("<"+name+">",temp,"")
	temp = replacestring("</"+name+">",temp,"")
	temp = replacestring("      ",temp,"")
	temp = replacestring("\n",temp,";")
	
	return temp
	
End

Function GCI_CopyParms()

	Wave MVW = $cMVW
	Wave TVW = $cTVW
	Wave Var = $cUVW
	
	Var[%GCI_Freq][0] 			= TVW[%ThermalFrequency][0]
	Var[%GCI_QF][0] 				= TVW[%ThermalQ][0]
	Var[%GCI_Thermalk][0] 		= MVW[%SpringConstant][0]
	
End

Function GCI_UpdateTable()

	Wave Var = $cUVW
	
	Var[%GCI_SaderK][0] 		= GCI_GetValue("k_sader")
	Var[%GCI_SaderKerr][0] 	= GCI_GetValue("percent")
	Var[%GCI_AValue][0] 		= GCI_GetValue("a_value")
	Var[%GCI_AValueErr][0] 	= GCI_GetValue("a_error")
	Var[%GCI_Samples][0]		= GCI_GetValue("samples")
	if (Var[%GCI_UploadK][0])
		Var[%GCI_DataUploaded][0]	= 1
	else
		Var[%GCI_DataUploaded][0]	= 0
	endif
	
End

Function GCI_GhostPanel()
	
	Wave Var = $cUVW
	
	DoWindow/F GCIPanel
	
	if (!v_flag)
		return 0
	endif
	
	String List = ControlNameList("GCIPanel",";")
	String List2 = ""
	
	List = RemoveFromList("GCI_UserName",List)				//	Username
	List = RemoveFromList("GCI_Password",List)				//	Password
	List = RemoveFromList("GCI_RegisterButton",List)		//	RegisterButton
	
	if (Var[%GCI_LoggedIn][0])
		MasterARGhostFunc("",List)
	else
		MasterARGhostFunc(List,"")
	endif
	
End

Function GCI_CheckProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	Wave Var = $cUVW
	
	Var[%GCI_UploadK][0] = checked
	
	GCI_Status()

End

Function GCI_Status()

	Wave Var = $cUVW
	Wave MVW = $cMVW
	SVAR Status	= $cStatus
  
	Status = ""

	if (Var[%GCI_UploadK][0] == 0)
		Status += "Approach 2: Only the frequency and quality factor are sent to\rthe GCI. The Sader Method uses the existing database to\rcalculate your spring constant and its uncertainty."
		Button GCI_Upload title="Calculate",win=GCIPanel
		SetVariable GCI_ThermalK valueBackColor=(65280,16384,16384),win=GCIPanel
	else
		Status += "Approach 1: The frequency, quality factor and spring constant\rare merged with the GCI database. The Sader Method gives a\rnew calculation of your spring constant and its uncertainty."
		Button GCI_Upload title="Upload & Calculate",win=GCIPanel
		SetVariable GCI_ThermalK valueBackColor=(65535,65535,65535),win=GCIPanel
	endif
	
	Status += "\r\r"

	if ((MVW[%AmpInvOLS][0] > 1.089e-07 && MVW[%AmpInvOLS][0] < 1.091e-07))
		Status += "InvOLS Calibrated: NO."
	else
		Status += "InvOLS Calibrated: YES."
	endif

//	if (Var[%GCI_Loggedin][0] == 0)
//		Status += "Logged In: No."+"\r"
//	else
//		Status += "Logged In: Yes."+"\r"
//	endif
//
//	if (Var[%GCI_Error][0] == 0)
//		Status += "Status: OK."+"\r"
//	elseif (Var[%GCI_Error][0] == 1)
//		Status += "Status: Connection Problem."+"\r"
//	else
//		Status += "Status: "+ GCI_GetString("message") + "\r"
//	endif
//
//	if (Var[%GCI_DataUploaded][0] == 0)
//		Status += "Data Uploaded: No."
//	else
//		Status += "Data Uploaded: Yes."
//	endif

	GCI_GhostPanel()
 
End

Function GCI_ErrorCheck(ConnectionError)
	Variable ConnectionError
	
	Wave Var		=	$cUVW
	SVAR Uname		= $cUname
	SVAR PWDtemp		= $cPWDtemp

	string Error = GCI_GetString("code")
	string ErrorMessage = GCI_GetString("message")
	
	if (ConnectionError)
		Var[%GCI_Error][0] = 1
		DoAlert 0, "Error: Problem accessing sadermethod.org"
		Var[%GCI_Loggedin][0] 	= 0
		Uname = ""
		PWDtemp = ""
		return 1
	elseif (!stringmatch(Error,"OK"))
		Var[%GCI_Error][0] = 2
		DoAlert 0, "Error: "+ ErrorMessage+"."
		return 1
	else
		Var[%GCI_Loggedin][0] 	= 1
		Var[%GCI_Error][0] 		= 0
		return 0
	endif
	
End