from time import sleep
import requests
import datetime
import getpass
from prettytable import PrettyTable
import os
import warnings

warnings.filterwarnings("ignore")
path = os.path.dirname(__file__)

s = requests.Session()
u = input("Enter your username: ")
pin = getpass.getpass("Enter your password: ")
s.auth = (u, pin)
r = s.get(f'https://DOMIN/api/', verify=False)

try:
    while(True):
        printTable = 0
        presentDate = datetime.datetime.now() - datetime.timedelta(1)
        unix_timestamp = datetime.datetime.timestamp(presentDate)
        print("Last scan timestamp: ", datetime.datetime.now())
        myTable = PrettyTable(['timestamp', 'alert', 'ruleSID', 'pcapName'])
        r = s.get(f'https://DOMIN/api/4.0/events/stored?time={unix_timestamp}&direction=newer', verify=False, headers = {'Accept': 'application/json'})
        data = r.json()
        for i in data['storedEvents']:
            for j in i['input_ebc']:
                if not (j['alert']['ruleMessage'].startswith('BETA')):
                    printTable = 1
                    myTable.add_row([j['@timestamp'], j['alert']['ruleMessage'], j['alert']['ruleSID'], i['input_search_id']])
                    pcap = s.get(f"https://DOMIN/api/4.0/results/{i['input_search_id']}/packets?pcapdownload=true", verify=False)
                    open(f"Downloads/{i['input_search_id']}.pcap", 'wb').write(pcap.content)

        if printTable:
            with open(f'{path}/data', "w") as f:
                f.writelines(str(myTable))
            os.system(f'code {path}/data')
        del data, myTable
        sleep(300)
        os.system('clear')

except KeyboardInterrupt:
    print("You typed CTRL + C, which is the keyboard interrupt exception")
