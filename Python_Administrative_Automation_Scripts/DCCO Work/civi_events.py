import pandas as pd
import os
from pythoncivicrm.pythoncivicrm import CiviCRM

# Establish Civi Connection
url = 'https://dev.dccos.org/sites/all/modules/civicrm/extern/rest.php'  # works
site_key = '15288a841a1073dbc58c5f314e031cd3'
api_key = 'DeCU6JakRlm2Y5K0'
civicrm = CiviCRM(url, site_key, api_key)

