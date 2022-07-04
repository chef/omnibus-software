#!/bin/bash

#To update the product_default_version
#cd omnibus-software/config/software
#sh update_prod_default_version.sh 

Prod_file="prod_default_version.json"
cd ../../config/software/
rm -rf $Prod_file 
echo "{" >> $Prod_file 
for FILE in *.rb; do 
	prod=$(echo "$FILE" |cut -d "." -f1);
        dv=$( grep "default_version" $FILE|  cut -d " " -f2) 
	if [ "$prod" = "cacerts" ]; then
		echo "\"$prod\": $dv ,">> $Prod_file; 
	else
		if echo $dv | grep -qE '[0-9]\.[0-9]+' ;then
		echo "\"$prod\": $dv ,">> $Prod_file; 
        	fi
	fi
done;
$(printf '%s\n' '$' 's/.$//' wq | ex $Prod_file)
echo "}" >> $Prod_file 
mv $Prod_file ../../.expeditor/Version_Inspector/
