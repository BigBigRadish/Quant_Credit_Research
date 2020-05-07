'Dynamic Hedging File Model Output Check & Email Verification

Option Explicit
Dim tradeDate
on error resume next

call timeStamp

tradeDate = timeStamp

x = msgbox(tradeDate)

set fso = createobject("scripting.filesystemobject").getfolder("G:\High Yield Active Core\Hedge Trading Program\Trading Program Redux\dailyTradeFile" & tradeDate & ".xlsm")

If fso.FileExists("G:\High Yield Active Core\Hedge Trading Program\Trading Program Redux\dailyTradeFile" & timeStamp & ".xlsm") Then
    x = msgbox("Dynamic Hedging Model ran successfully as of " & FormatDateTime(Now,2) & ". Please check if the dynamic hedging trade file was sent out by either Jakob Bak or Brian Fagan. Thanks", &h51000,     "Dynamic Hedging Model Reminder")
Else
    x = msgbox("The Dynamic Hedging model has not been executed as of "& FormatDateTime(Now,2) &". Please check if Jakob Bak or Brian Fagan are currently running the model or if there is a problem. Thanks",     &h51000, "Dynamic Hedging Model Reminder")
End If


Function timeStamp()

Dim t,d,m,y

on error resume next
    
    t = Now
    d = right("0" & datePart("d",t),2) + 1
    m = right("0" & datePart("m",t),2)
    y = datePart("yyyy",t)
    timeStamp = y & m & d

End Function
