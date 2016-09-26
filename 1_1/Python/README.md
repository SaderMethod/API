# Version 0.10 - Sader Method API Version 1.1

This is a proof of concept code (with 3 basic functions) which will allow you to implement in your Python based software.
See the Asylum Research (IgorPro6 or IgorPro7) for an example of a full functionality implementation.

**For Development**
Please use https://v011.sadermethod.org/api/1.1/api.php. You will need to register online at https://v011.sadermethod.org. 

**For Production**
Please use https://sadermethod.org/api/1.1/api.php. You will need to register online at https://sadermethod.org. 

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

Reference: [Sader et al., arXiv:1605.07750 (2016).](https://arxiv.org/abs/1605.07750)


