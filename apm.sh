#!/bin/bash

#Project 1 - Dom, Justin, and Jonathan
spawn(){
#Passed in the IP as an argument
	#spawn processes
	pwd	
	./APM1 $1 & #& symbol allows for simultaneous 
	pd1=$!
	echo "Started Process #1 with ID #: ${pd1}"
	./APM2 $1 &
	pd2=$!
	echo "Started Process #2 with ID #: ${pd2}"
	./APM3 $1 &
	pd3=$!
	echo "Started Process #3 with ID #: ${pd3}"
	./APM4 $1 &
	pd4=$!
	echo "Started Process #4 with ID #: ${pd4}"
	./APM5 $1 &
	pd5=$!
	echo "Started Process #5 with ID #: ${pd5}"
    ./APM6 $1 &
	pd6=$!
	echo "Started Process #6 with ID #: ${pd6}"
        echo "Started ifstat on the above processes"
	ifstat -a -d 1	
}

ps_level () {
        cpu=$(ps -p "$pd1" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd1" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM1_metrics.csv"
        cpu=$(ps -p "$pd2" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd2" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM2_metrics.csv"
        cpu=$(ps -p "$pd3" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd3" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM3_metrics.csv"
        cpu=$(ps -p "$pd4" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd4" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM4_metrics.csv"
        cpu=$(ps -p "$pd5" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd5" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM5_metrics.csv"
        cpu=$(ps -p "$pd6" -o %cpu | sed -n 2p)
        mem=$(ps -p "$pd6" -o %mem | sed -n 2p)
        echo $1,$cpu,$mem >> "APM6_metrics.csv"
}

sysData () {
	rx_rate=$(ifstat ens33 | grep ens33 | sed s/K//g | awk '{print $7}')
	tx_rate=$(ifstat ens33 | grep ens33 | sed s/K//g | awk '{print $9}')
	write_speed=$(iostat -d -k sda | awk '/^\s*sda/ {print $4}')
	totalSpace=$(df -hm / | sed -n '2p' | xargs | cut -d ' ' -f 4)
	echo $1,$rx_rate,$tx_rate,$write_speed,$totalSpace >> "System_metrics.csv"
}

cleanup(){
	pkill -f -9 APM1
	pkill -f -9 APM2
	pkill -f -9 APM3
	pkill -f -9 APM4
	pkill -f -9 APM5
	pkill -f -9 APM6
	pkill -f -9 "ifstat"
    exit 0
}

trap cleanup SIGINT #If the user clicks CTRL+C (^C) then it  qis accounted for
read -p "Enter the IP address that you would like to use (from the NIC):" IP_ADDRESS
spawn "$IP_ADDRESS"
#while loop start for running the script every 5 seconds
SECONDS=0
#Main While Loop

	while true ; #Infinte Loop
	do
		sysData $SECONDS
		#sleep for 5 seconds
		sleep 5
		if [[ $duration -ge 900 ]] 
                then
			cleanup
		fi
		echo "Collected Data at $duration Seconds" #Every 5 seconds, this is displayed
        ps_level $SECONDS
		duration=$SECONDS
	done

