"""
This script is designed to monitor your personal Outlook email . The script can handle certain things user defined
with incoming email. Just setup flags for what to do with specific email and let it run all day.
Built from Python Anaconda 3.6
"""

import win32com.client
import pythoncom


class Handler_Class(object):
    def OnNewMailEx(self, receivedItemsIDs):
        # RecrivedItemIDs is a collection of mail IDs separated by a ",".
        # You know, sometimes more than 1 mail is received at the same moment.
        for ID in receivedItemsIDs.split(","):
            mail = outlook.Session.GetItemFromID(ID)
            subject = mail.Subject
            body = mail.Body

            # Insert things to do to email here if body or subject matches certain criteria:
            # Additional reference for mail object attributes:
            # https://msdn.microsoft.com/en-us/library/microsoft.office.interop.outlook.mailitem_properties.aspx
            # http://www.icodeguru.com/WebServer/Python-Programming-on-Win32/ch14.htm

            print("New Email!")
            print("Title: " + str(subject))
            print("Body: " + str(body))


outlook = win32com.client.DispatchWithEvents("Outlook.Application", Handler_Class)

# Infinite loop that waits when new email is received
pythoncom.PumpMessages()
