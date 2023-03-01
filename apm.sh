#!/bin/bash

#Project 1 - Dom, Justin, and Jonathan
spawn(){
#Passed in the IP as an argument
	#spawn processes
	sudo pwd	
	sudo ./APM1 $1 & #& symbol allows for simultaneous 
	pd1=$!
	echo "Started Process #1 with ID # : ${pd1}"
	sudo ./APM2 $1 &
	pd2=$!
	echo "Started Process #2 with ID #: ${pd2}"
	sudo ./APM3 $1 &
	pd3=$!
	echo "Started Process #3 with ID #: ${pd3}"
	sudo ./APM4 $1 &
	pd4=$!
	echo "Started Process #4 with ID #: ${pd4}"
	sudo ./APM5 $1 &
	pd5=$!
	echo "Started Process #5 with ID #: ${pd5}"
	sudo 
./APM6 $1 &
	pd6=$!
	echo "Started Process #6 with ID #: ${pd6}"
        echo "Started ifstat on the above processes"
	ifstat -a -d 1	
}
cleanup(){
#KILL THEM ALL ;)
	kill -9 $pd1
	kill -9 $pd2 
	kill -9 $pd3
	kill -9 $pd4
	kill -9 $pd5
	kill -9 $pd6
	pkill -f -9 "ifstat"
exit $?
}
 	trap cleanup SIGINT #If the user clicks CTRL+C (^C) then it  qis accounted for
read -p "Enter the IP address that you would like to use (from the NIC):" IP_ADDRESS
spawn "$IP_ADDRESS"
#while loop start for running the script every 5 seconds
SECONDS=0
#Main While Loop

	while true ; #Infinte Loop
	do
		#sleep for 5 seconds
		sleep 5
		if [[ $duration -ge 900 ]] 
                then
			cleanup
		fi
		echo "Collected Data at $duration Seconds" #Every 5 seconds, this is displayed
		duration=$SECONDS
	done
	
