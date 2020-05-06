import pandas as pd
import os
from pythoncivicrm.pythoncivicrm import CiviCRM

'''
About: CiviCRM is a CMS Framework for non-profit organization websites. 
This script leverages the CiviCRM API and was made to automate/update 
Contribution records.
'''

# Establish Civi Connection
url = 'https://dev.dccos.org/sites/all/modules/civicrm/extern/rest.php'  # My CMS Site
site_key = '####################'  # this is private :P
api_key = '#####################'  # this is private :P
civicrm = CiviCRM(url, site_key, api_key)

# PART I ##########################################################################################

# my contact id is 1799
# set working directory
os.chdir('C:\\Users\\Matt Wilchek\\Documents')

# read donation data
donations_2015 = pd.read_csv('donations_2015.csv')
donations_2015['contact_id'] = 0

search_results = civicrm.get('Contact', limit=5000)
contacts = pd.DataFrame(search_results)

search_results2 = civicrm.get('Contribution', limit=5000)
contributions = pd.DataFrame(search_results2)

# Match contact IDs from contacts to data
for index, row in donations_2015.iterrows():
    print("Looking at: " + str(row['FirstName'] + " " + str(row['LastName'])))
    for i, r in contacts.iterrows():
        if row['FirstName'] == r['first_name'] and row['LastName'] == r['last_name']:
            print("****MATCH FOUND****")
            print("Current Contact ID: " + str(row['contact_id']))
            db_id = r['contact_id']
            donations_2015.at[index, 'contact_id'] = db_id
            print("New Contact ID: " + str(row['contact_id']))
            break

# PART II #########################################################################################

# Write file with matched contact IDs to Upload to Civi
donations_2015.to_csv('donations_for_civi_upload.csv', index=False)

# PART III ########################################################################################

# Read matched file made
donations_2015 = pd.read_csv('donations_for_civi_upload.csv')

# civicrm.add_contribution(donations_2015['contact_id'][0], donations_2015['Gross'][0],
#                         donations_2015['Financial Type'][0])

# Update Contributions dataframe
search_results2 = civicrm.get('Contribution', limit=5000)
contributions = pd.DataFrame(search_results2)

# Filter Civi Contributions by CY
civi_records_2015 = contributions[contributions['receive_date'].str.contains("2015")]
civi_records_2016 = contributions[contributions['receive_date'].str.contains("2016")]
civi_records_2017 = contributions[contributions['receive_date'].str.contains("2017")]

# Filter data file records by CY
file_records_2015 = donations_2015[donations_2015['Date'].str.contains("2015")]
file_records_2016 = donations_2015[donations_2015['Date'].str.contains("2016")]
file_records_2017 = donations_2015[donations_2015['Date'].str.contains("2017")]

# For each new record in Civi from uploaded file and the year 2015
for i, r in civi_records_2015.iterrows():
    # Get the Civi associated Contribution record ID
    cont_id = r['contribution_id']
    cont_id = int(cont_id)
    # Iterate through donations data
    for x, y in file_records_2015.iterrows():
        # Find matching record of Civi Contribution and record in uploaded file
        if r['contact_id'] == y['contact_id'] and r['total_amount'] == y['Gross']:
            # Check if file record contribution was PayPal
            if y['Method'] == "PayPal":
                # If it is, set Civi Contribution field 'Payment Method' to PayPal
                civicrm.setvalue(entity='Contribution', db_id=cont_id, field='payment_instrument_id', value=1)
                civicrm.update(entity='Contribution', db_id=cont_id)

            # Else leave it as check and continue

# TEST CODE ##################################################################################

# test = contributions.tail(1)
# test.columns.values

# get contribution ID
# cont_id = test['contribution_id'].values[0]
# cont_id = int(cont_id)

# changes from check to PayPal
# civicrm.setvalue(entity='Contribution', db_id=cont_id, field='payment_instrument_id', value=1)
# confirm update
# civicrm.update(entity='Contribution', db_id=cont_id)

# date = "2015-12-17 10:10:10"

# add fee amount
# civicrm.setvalue(entity='Contribution', db_id=cont_id, field='amount_level', value="test")
