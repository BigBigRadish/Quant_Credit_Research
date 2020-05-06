"""
This script is designed to monitor Outlook email for as specific inbox that is not personal. So
if you have multiple mailboxes setup in outlook, this script can handle certain things user defined
with incoming email. Just setup flags for what to do with specific email and let it run all day.
Built from Python Anaconda 3.6
"""

import win32com.client
from datetime import datetime
import csv
import numpy as np

# instantiate outlook application reference
outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")

# instantiate Outlook Application object for a specific mailbox (not personal)
recip = outlook.CreateRecipient("CompanyName@company.com")  # email of user or organization email

# create reference to inbox of specific mailbox
inbox = outlook.GetSharedDefaultFolder(recip, 6)  # 6 points to inbox
messages = inbox.Items
messages.Sort("[ReceivedTime]", True)

# identify first email in inbox and validate mail item
first_message = messages.GetFirst()
first_subject = first_message.Subject
print("Current first email: " + str(first_subject))

with open('emails_file.csv', 'a') as csvfile:
    names = ['Sent On', 'Sender Name', 'Recipients', 'Subject', 'Body']
    w = csv.DictWriter(csvfile, fieldnames=names, lineterminator='\n')
    w.writeheader()

    for message in messages:
        sent_on = message.SentOn
        present = datetime.now()

        # Just collect new emails for today and append to existing dataset
        if present.strftime("%Y-%m-%d") == sent_on.strftime("%Y-%m-%d"):
            print("New email in mailbox.")
            sender_name = message.SenderName
            recipients = message.Recipients
            items = []
            for index in recipients:
                items.append(str(index) + "/")
            recipients_data = ''.join(items)
            subject = message.Subject
            body = message.Body

            try:
                w.writerow({'Sent On': np.unicode(sent_on.strftime("%m/%d/%Y")),
                            'Sender Name': np.unicode(sender_name), 'Recipients': np.unicode(recipients_data),
                            'Subject': np.unicode(subject), 'Body': np.unicode(body)})
            except UnicodeEncodeError:
                continue

csvfile.close()
print("All Company Emails Extracted...")

__author__ = 'Matt Wilchek'
