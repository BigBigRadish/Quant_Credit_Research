"""
This script is designed to monitor Outlook email for as specific inbox that is not personal. So
if you have multiple mailboxes setup in outlook, this script can handle certain things user defined
with incoming email. Just setup flags for what to do with specific email and let it run all day.
Built from Python Anaconda 3.6
"""

import win32com.client
import time

# instantiate outlook application reference
outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")

# instantiate Outlook Application object for a specific mailbox (not personal)
recip = outlook.CreateRecipient("email@company.com")

# create reference to inbox of specific mailbox
inbox = outlook.GetSharedDefaultFolder(recip, 6)  # 6 points to inbox
messages = inbox.Items

# identify first email in inbox and loop from that
first_message = messages.GetFirst()
first_subject = first_message.Subject
print("Current first email: " + str(first_subject))

# create additional flags what to do with certain email in loop block below
# such as look for specific words in a subject or body
# after flag catches perform certain actions such as replying or saving content
# reference: http://www.icodeguru.com/WebServer/Python-Programming-on-Win32/ch14.htm
#
# Currently the below will print to the console when a new email is received, the subject and body of the email,
# then re-check after 10 seconds

while True:
    messages = inbox.Items
    top_message = messages.GetFirst()
    subject = top_message.Subject

    if subject != first_subject:
        print("New Email in (Company Name) Inbox")
        first_subject = subject
        body = top_message.Body
        print("Title: " + str(subject))
        print("Body: " + str(body))
        time.sleep(10)

    else:
        print("No new email yet...")
        time.sleep(10)

__author__ = 'Matt Wilchek'