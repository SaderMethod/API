# Version 0.20 - Sader Method API Version 1.1

This is a proof of concept code (with 3 basic functions) which will allow you to implement in your Python based software.
See the Asylum Research (IgorPro6 or IgorPro7) for an example of a full functionality implementation.

**Function 1:**
`SaderGCI_GetLeverList(UserName, Password)`

Returns list of LeverNames with corresponding LeverNumber in brackets

**Function 2:**
`SaderGCI_CalculateK(UserName, Password, LeverNumber, Frequency, QFactor)`

Returns k for LeverNumber using Frequency and Qfactor

**Function 3:**
`SaderGCI_CalculateAndUploadK(UserName, Password, LeverNumber, Frequency, QFactor, SpringK)`

Returns k for LeverNumber using Frequency and Qfactor and uploads the entry to the online database

_Note: percent is the 95% confidence interval error in both k and A_

Please email feedback (quoting version number and AFM type):  support@sadermethod.org

**NOTE: Take measurements of the fundamental flexural mode in air. The GCI reports the static normal spring constant at the imaging tip position.**

Reference: [Sader et al., Review of Scientific Instruments, 87, 093711 (2016).](http://scitation.aip.org/content/aip/journal/rsi/87/9/10.1063/1.4962866)


