#!/bin/bash
PKGS=$@;
WORDCOUNT=`echo $PKGS | wc  -w`
LAST=$WORDCOUNT-1
COUNT=0
YAML=""

	for RPM in `echo $PKGS`
	do
		if (( $COUNT == 0 ))
		then
			YAML=$(echo "['$RPM',")
			if (( $COUNT == $LAST ))
			then

				YAML=$(echo "['$RPM']")
			fi
			
		elif (( $COUNT == $LAST ))
		then	
			YAML=$(echo "$YAML'$RPM']")

		else
			YAML=$(echo "$YAML'$RPM',")
		fi

	COUNT=$((COUNT+1))
	done
#	return  $YAML

echo $YAML
