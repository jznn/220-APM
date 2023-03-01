ps_level () {
    for ((i=1;i<=6;i++))
    do
        psname$(ps aux | grep "APM${i}" | awk {print $2})
        cpu=$(ps aux | grep "APM${i}" | awk {print $3})
        mem=$(ps aux | grep "APM${i}" | awk {print $4})
        echo Seconds,$cpu,$mem >> ${psname}_metrics.csv 
    done
}
