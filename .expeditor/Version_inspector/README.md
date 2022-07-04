# Version Inspector 
	python based utility software that can be used to find the latest version information for the omnibus-software packages .

## Execute the below command to install the dependencies.
	$pip3 install -r requirements.txt

## SW-Version-update.py 
	python script to get the latest version of products.
		command to run the script
		$python3 SW-Version-update.py [json]
			 Pass 'json' as CLA for json o/p
			 1. checks latest version  for all the products and lists the product, default version and latest version with url
			 2. checks for latset version for a particular product
			 3. List the products that needs to be checked for latest version manually
 
## update_prod_default_version.sh 
	rebase your branch with main to get the latest updated version updates and execute this script, which generates update_prod_default_version.json
## update_prod_list.sh 
	Not necessary to run all the time. ALl the product are upto date. Dont run this script until unless it is required. This script generates prod_list.json. 
## manual_prod_list.json 
	contains the list of products that needs to be checked for latest version manually.	
