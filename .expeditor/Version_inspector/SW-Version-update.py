from math import prod
import requests
from bs4 import BeautifulSoup
import re
from packaging import version
import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


pf = open('prod_list.json')
mf = open('manual_prod_list.json')
pvf = open('prod_default_version.json')


file_data_pf = json.load(pf)
file_data_mf = json.load(mf)
file_data_pvf = json.load(pvf)

prod_lst=list(file_data_pf.keys()) #  to validate the product 
manual_prod_list=list(file_data_mf.keys())
prod_def_ver_list=list(file_data_pvf.keys())

choice = int(input("Enter \n1 - for Latest version check for all products.\n2 - Check for a particular S/W \n3 - List all S/W that needs to be handled manually \n"))

def get_latest_version(url,expr,product):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    

    for data in soup(['style', 'script']):
        data.decompose()

    list_of_contents = ' '.join(soup.stripped_strings).split(" ")
    
    r = re.compile(expr)
    filtered_list = list(filter(r.match, list_of_contents)) # Read Note
    
    print("======================================================")
    versions_string = " ".join(filtered_list)

    if product in ["server-open-jre"]:
        extracted_versions = re.findall(r"\d[\.\d]*\d_\d+", versions_string)
    elif(product in ["libedit"]):
        extracted_versions = re.findall(r"\d+-[\.\d]*\d", versions_string)
    else:
        extracted_versions = re.findall(r"\d[\.\d]*\d", versions_string)
    #print(extracted_versions)
    
    highest_version = extracted_versions[0]
    for i in range(1,len(extracted_versions)):
    #print("Comparing ",extracted_versions[i]," and ",highest_version)
        if(version.parse(extracted_versions[i]) > version.parse(highest_version)):
            highest_version = extracted_versions[i]
    return highest_version

def mail_sender(mail_content):
    sender_address = ''
    sender_pass = ''
    receiver_address = ''
    #Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = receiver_address
    message['Subject'] = 'Version Updates Automation!'   #The subject line
    #The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'plain'))
    #Create SMTP session for sending the mail
    session = smtplib.SMTP('smtp.gmail.com',465) #use gmail with port
    session.starttls() #enable security
    session.login(sender_address, sender_pass) #login with mail_id and password
    text = message.as_string()
    session.sendmail(sender_address, receiver_address, text)
    session.quit()
    print('Mail Sent')


def create_github_issue(product,ticket_title,product_url):

    github_token = ""
    repo_owner = ""
    repo_name = ""

    title = ticket_title
    body = product_url

    url = "https://api.github.com/repos/%s/%s/import/issues"%(repo_owner,repo_name)
    headers={
        "Authorization":"token %s"%(github_token),
        "Accept": "application/vnd.github.golden-comet-preview+json"
    }

    data = {
        "issue":{
            "title":title,
            "body":body
        }
    }
    payload = json.dumps(data)

    response = requests.request("POST",url,data=payload,headers=headers)

    return(response)

if(choice == 1):
    print("Checking for all products........")
    mail_content = ""
    for i in file_data_pf:
        print("======================================================")
        print("PRODUCT : ",i)
        product_details = file_data_pf[i]
        #print (product_details)
        highest_version = get_latest_version(product_details["url"],product_details["expr"],i)
        default_version = file_data_pvf[i]
        print("Latest software version available :",highest_version)
        print("Default version :",default_version)
        
        if(default_version == highest_version):
            print("No version updates on the product")
        else :
            print("URL :",product_details["url"] )
            print("------------------------------------------------------")
            print("Confirm if ",highest_version," is already updated / present in version list in ",i,".rb")
            print("------------------------------------------------------")
        print("======================================================")
        mail_content += "======================================================\n"+"PRODUCT : "+str(i)+"\nDefault version :"+str(default_version)+"\nLatest software version available :"+str(highest_version)+"\n======================================================"
    #print(mail_content)
    #mail_sender(mail_content)

elif(choice == 2 ):
    product = input("Enter the product name\n")
    if product in manual_prod_list :
        if product in prod_def_ver_list :
            manual_product_details=file_data_mf[product]
            manual_product_url = manual_product_details["url"]
            default_version = file_data_pvf[product]

            print("\n======================================================")
            print("NOTE :",product, " Package -latest version has to be checked manually,Check below URL for Latest-version ")
            print("\n======================================================")
            print(" PRODUCT :",product)
            print("------------------------------------------------------")
            print(" Default version :",default_version)
            print(" URL  :",manual_product_url)
            print("======================================================")
        else :
            print("ERROR : Invalid Product")

    elif product in prod_lst : 
        if product in prod_def_ver_list :
            product_details = file_data_pf[product]
            url = product_details["url"]
            expr = product_details["expr"]
            default_version = file_data_pvf[product]
            print("======================================================")
            print("PRODUCT : ",product)
       
            highest_version = get_latest_version(product_details["url"],product_details["expr"],product)
            print("======================================================")
            print("Default version :",default_version)
            print("Latest software version available :",highest_version)
            #ticket_title = product+" version update from "+default_version+" to "+highest_version
            print("======================================================")
            if(default_version==highest_version):
                print("No version updates on the product")
                print("======================================================")
            else :
                print("URL :",product_details["url"] )
                print("------------------------------------------------------")
                print("Confirm if ",highest_version," is already updated / present in version list in ",product,".rb")
                print("------------------------------------------------------")
           #else :
            #     ch=input("Would you like to create a ticket for this version-update track ?  y/n :").lower()
            #    if(ch == 'y'):
            #        response = create_github_issue(product,ticket_title,url)
                    #print(response.content)
        else :
            print("ERROR : Invalid Product")
    else :
            print ("ERROR : Product / Package Name  does'nt exists in the check_list ")

elif( choice == 3 ):
    print("List of product needs to be verified manually ")
    print("prod_list",manual_prod_list)
    for product in manual_prod_list:
        manual_product_details=file_data_mf[product]
        manual_product_url=manual_product_details["url"]
        default_version=file_data_pvf[product]
        print("\n======================================================")
        print(" PRODUCT :",product)
        print("------------------------------------------------------")
        print(" Default version :",default_version)
        print(" URL  :",manual_product_url)
        print("======================================================")
else:
    print("Invalid choice")





