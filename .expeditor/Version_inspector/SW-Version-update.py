from math import prod
import requests
from bs4 import BeautifulSoup
import re
from packaging import version
import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import sys

json_flag = ""
try:
    json_flag = sys.argv[1]
except:
    print("No args passed")

pf = open('prod_list.json')
mf = open('manual_prod_list.json')
pvf = open('prod_default_version.json')

file_data_pf = json.load(pf)
file_data_mf = json.load(mf)
file_data_pvf = json.load(pvf)

prod_lst=list(file_data_pf.keys()) #  to validate the product 
manual_prod_list=list(file_data_mf.keys())
prod_def_ver_list=list(file_data_pvf.keys())

choice = int(input("Enter \n1 - Check Latest version for all products.\n2 - Check Latest Version for a particular product \n3 - List all S/W & URL that needs to be handled manually \n"))

def get_latest_version(url,expr,product):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    for data in soup(['style', 'script']):
        data.decompose()

    list_of_contents = ' '.join(soup.stripped_strings).split(" ")

    
    r = re.compile(expr)
    filtered_list = list(filter(r.match, list_of_contents)) # Read Note
    
    versions_string = " ".join(filtered_list)

    if product in ["server-open-jre"]:
        extracted_versions = re.findall(r"\d[\.\d]*\d_\d+", versions_string)
    elif(product in ["libedit"]):
        extracted_versions = re.findall(r"\d+-[\.\d]*\d", versions_string)
    else:
        extracted_versions = re.findall(r"\d[\.\d]*\d", versions_string)

    product_error = []
    try:
        highest_version = extracted_versions[0]
        for i in range(1,len(extracted_versions)):
        #print("Comparing ",extracted_versions[i]," and ",highest_version)
            if(version.parse(extracted_versions[i]) > version.parse(highest_version)):
                highest_version = extracted_versions[i]
        return highest_version
    except:
        product_error.append(prod)
    
    print(product_error)

def mail_sender(mail_content):
    sender_address = 'poorndm@progress.com'
    sender_pass = ''
    receiver_address = 'poorndm@progress.com'
    #Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = receiver_address
    message['Subject'] = 'Omnibus-S/W version Updates!'   #The subject line
    #The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'plain'))
    #Create SMTP session for sending the mail
    session = smtplib.SMTP('smtp.progress.com',465) #use gmail with port
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
    json_output={}
    for i in file_data_pf:
       
        product_details = file_data_pf[i]
        #print (product_details)
        highest_version = get_latest_version(product_details["url"],product_details["expr"],i)
        default_version = file_data_pvf[i]
        
        if(json_flag=="json"):
            if(default_version==highest_version):
                json_output[i] = {"Default_Version":default_version,"Latest_Version":highest_version, "Product_URL":product_details["url"],"Manual_Check":"No","Update_Required":"No"}
            else:
                json_output[i] = {"Default_Version":default_version,"Latest_Version":highest_version, "Product_URL":product_details["url"],"Manual_Check":"No","Update_Required":"Yes"}

        else:
            print("======================================================")
            print("PRODUCT : ",i)
            print("Latest software version available :",highest_version)
            print("Default version :",default_version)
            if(default_version == highest_version):
                print("No version updates on the product")
            else :
                print("URL :",product_details["url"] )
                print("------------------------------------------------------")
                prod=i+".rb"
                print("Check if",highest_version,"is stable version and already updated in version list in ",prod)
                print("------------------------------------------------------")
            print("======================================================")

    if(json_flag=="json"):
        print(json_output)
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

            json_output = {"Product":product, "Default_Version":default_version, "Product_URL":manual_product_url,"Manual_Check":"Yes"}
            if(json_flag=="json"):
                print(json_output)
            else:
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
            highest_version = get_latest_version(product_details["url"],product_details["expr"],product)

            if(default_version==highest_version):
                json_output = {"Product":product, "Default_Version":default_version,"Latest_Version":highest_version, "Product_URL":url,"Manual_Check":"No","Update_Required":"No", "Comment": ""}
            else:
                json_output = {"Product":product, "Default_Version":default_version,"Latest_Version":highest_version, "Product_URL":url,"Manual_Check":"No","Update_Required":"Yes", "Comment":"Verify if Latest version is present in Version list"}

            if(json_flag=="json"):
                print(json_output)
            else:    
                print("======================================================")
                print("PRODUCT : ",product)
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
                    prod=product+".rb"
                    print("Check if",highest_version," is stable version and already present in version list in ",prod)
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
    
    json_output={}

    for product in manual_prod_list:
        manual_product_details=file_data_mf[product]
        manual_product_url=manual_product_details["url"]
        default_version=file_data_pvf[product]

        if(json_flag=="json"):
            json_output[product]={"Default_Version":default_version,"Product_URL":manual_product_url}
        else:
            print("\n======================================================")
            print(" PRODUCT :",product)
            print("------------------------------------------------------")
            print(" Default version :",default_version)
            print(" URL  :",manual_product_url)
            print("======================================================")
    if(json_flag=="json"):
        print(json_output)
    else:
        print("List of product needs to be verified manually ")
        print("prod_list",manual_prod_list)    
else:
    print("Invalid choice")
