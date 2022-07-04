#to update the prod_list.json 
#cd omnibus-software/config/software
#sh update_prod_list.sh

prod_file="prod_list.json"
cd ../../config/software/
rm $prod_file
echo "{" >>$prod_file
for FILE in *.rb; do 
    if ! grep -q deprecated $FILE  ; then
	    echo "File name is :$FILE"
	    prod=$(echo "$FILE" |cut -d "." -f1); 
      dv=$( grep "default_version" $FILE|  cut -d " " -f2) 
	    if echo $dv | grep -qE '[0-9]\.[0-9]+' ;then
	  	    url=$(grep "https" $FILE | grep tar | tail -1 |  cut -d ":" -f2 -f3 | cut -d "-" -f1)
		      if [ ! -z "$url" ];then
			       echo "\"$prod\": {" >> $prod_file; 
			       url1=$(dirname $url)
			       echo "\"url\": $url1\"," >> $prod_file ; 
			       if [ $prod == "openssl-fips" ] || [ $prod == "postgresql" ] ;then
				        expr1="^v\\\\\d[\\\\\.\\\\\d]*\\\\\d"
			  	      echo $expr1
			       else
				         expr1="^($prod-)\\\\\d[\\\\\.\\\\\d]*\\\\\d(\\\\\.tar\\\\\.gz)$"
				         echo "EXPR=$expr1"
			       fi
 			      echo "\"expr\": \"$expr1\"">>$prod_file 
			      echo "},">>$prod_file		
		    fi
	    fi
   fi
done;
$(printf '%s\n' '$' 's/.$//' wq | ex $prod_file)
echo "}" >>$prod_file 
#mv $prod_file ../../.expeditor/Version_Inspector/
