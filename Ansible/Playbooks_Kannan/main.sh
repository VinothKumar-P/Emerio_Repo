#!/bin/bash
echo $stack;
echo $DEPLOY_PKG
export ANSIBLE_FORCE_COLOR=true


if [ -z "$RELEASE_NAME" ]
then
	export RELEASE_NAME="TEST"
fi


MAIN_YAML="/usr/local/ansible/playbooks/sites.yml"

####Remove sites.retry
rm -f /usr/local/ansible/playbooks/sites.retry

checkSitesFile()
{
	if [ -f /usr/local/ansible/playbooks/sites.retry ]
	then
       		exit -1;
	fi
}

#####Deploying Tomee RPMS
/usr/local/ansible/playbooks/tomee/tomee.sh

checkSitesFile

#####Deploying WSAPI RPMS
/usr/local/ansible/playbooks/wsapi/wsapi.sh

checkSitesFile

for RPM in `echo $DEPLOY_PKG`
do

	checkSitesFile

        ######### Package to be removed####################
        REMOVE=`echo $RPM | awk -F"-" {'print $1"-"$2'}`

        ############################QUARTZ  package ###################################

        if [[ $REMOVE == *"TRMB-quartzap"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.quartz pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=quartz" 
        fi

        
        ############################JAVA1 host packages ###################################

        if [[ $RPM == *"TRMB-driverauthproc"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=driverauth"  
        fi


        if [[ $RPM == *"TRMB-expap"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.exception pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=exception"  
        fi


        if [[ $RPM == *"TRMB-fdcidtlmap"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=idtlandmark-fdc"  --check
        fi


        if [[ $RPM == *"TRMB-mr3pp"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=mr3pp"  --check
        fi

		###########################JAVA1/2 host package########################
		
        if [[ $REMOVE == *"TRMB-upload" ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.upload pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=upload"  
        fi
		
		
	if [[ $RPM == *"TRMB-dubatchap"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=dubatchap"  --check
        fi

		
	if [[ $RPM == *"TRMB-dusg"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=dusg"  --check
        fi
		
		############################# Java 3 host package ##########################
		
	if [[ $RPM == *"TRMB-perfman"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=perfman" 
        fi
		
		
	if [[ $RPM == *"TRMB-fdcdotap"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=dot-agent"
        fi
		
		
	if [[ $RPM == *"TRMB-mobileaddagt"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=mobile-address-agt"  --check
        fi
		
		
	if [[ $RPM == *"TRMB-orgmigration"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=orgmigration"  --check
        fi
		
		
	if [[ $RPM == *"TRMB-empreportprocessor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=empreportprocessor"  --check
        fi
		
		
	if [[ $RPM == *"TRMB-privatelandmark"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java3 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=privatelandmark"  --check
        fi
		
		
		###########################JAVA4 host package########################
		
	if [[ $RPM == *"TRMB-outboundserver"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java4 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=outbound-server"  --check
        fi
		
		
	if [[ $RPM == *"TRMB-packetprocessor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java4 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=pktprocessor" 
        fi
		
		
	if [[ $RPM == *"TRMB-fueltranproc"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java4 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=fueltranproc"  --check
        fi
	
	#######FDC Agents #####################
	
	if [[ $RPM == *"TRMB-FDCArchiveAgent"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.fdc pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=FDCArchiveAgent"  --check
        fi
		
	if [[ $RPM == *"TRMB-FDCGeoServiceAgent"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.fdc pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=FDCGeoServiceAgent"  --check
        fi
		
	if [[ $RPM == *"TRMB-FDCRevGeoAgent"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.fdc pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=FDCRevGeoAgent"  --check
        fi
		
	if [[ $RPM == *"TRMB-FDCCMPUpdateAgent"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.fdc pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=FDCCMPUpdateAgent"  --check
        fi
	
	if [[ $RPM == *"TRMB-FDCRevGeoMonitor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.dc2 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=FDCRevGeoMonitor"  --check
        fi

        if [[ $RPM == *"TRMB-diagnosticsprocessor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.dc1 pkg_install=$RPM pkg_remove=TRMB-diagnosticsprocessor.noarch role=diagnosticsprocessor" 
        fi

        if [[ $RPM == *"TRMB-wmscheduleconstructor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.javatomcat pkg_install=$RPM  role=wmscheduleconstructor pkg_remove=$REMOVE releasename=$RELEASE_NAME " 
        fi

        if [[ $RPM == *"TRMB-wmtravelmodelconstructor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.javatomcat pkg_install=$RPM  role=wmtravelmodelconstructor pkg_remove=$REMOVE releasename=$RELEASE_NAME "
        fi
	
        ############################Tokenmediator  package ###################################

        if [[ $REMOVE == *"TRMB-tokenmediator"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.apimanager pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=apimanager"
        fi


        ############################RFFprocessor  package ###################################

        if [[ $REMOVE == *"TRMB-rffprocessor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java45 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=rollingfreezeframeprocessor"
        fi


        ############################WMLeanermgr  package ###################################

        if [[ $REMOVE == *"TRMB-wmlearnermgr"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.javatomcat pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=wmlearnermgr"
        fi


        ############################DriverSafetyProcessor  package ###################################

        if [[ $REMOVE == *"TRMB-driver-safety-processor"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java45 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=driversafetyprocessor"
        fi


        ############################PacketBroker  package ###################################

        if [[ $REMOVE == *"TRMB-packetbroker"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.java45 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=packetbroker"
        fi

        ############################ConfigServer  package ###################################

        if [[ $REMOVE == *"TRMB-configserver"* ]]
        then
                ansible-playbook $MAIN_YAML --extra-vars "host=$stack.dc1 pkg_install=$RPM pkg_remove=$REMOVE releasename=$RELEASE_NAME role=configserver"
        fi

		
done

#TRMB-FDCArchiveAgent TRMB-FDCGeoServiceAgent TRMB-FDCRevGeoAgent TRMB-FDCCMPUpdateAgent TRMB-FDCRevGeoMonitor  Done
#TRMB-diagnosticsprocessor TRMB-lookupagent  TRMB-eatonadapter TRMB-dispatchserver TRMB-esbcsa TRMB-FDCMsgAdapter
