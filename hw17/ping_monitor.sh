#!/bin/bash

# Prompt user for target address
read -p "Enter IP/hostname to ping: " host

# Failed attempts counter
fail_count=0

echo "--------------------------------------------------"
echo "Starting continuous ping monitoring for: $host"
echo "Check interval: 1 second"
echo "Threshold values:"
echo " - Latency > 100 ms is considered high"
echo " - 3 consecutive failures is critical"
echo "Press Ctrl+C to stop"
echo "--------------------------------------------------"

while true; do
    # Execute ping, suppress errors
    ping_result=$(ping -c 1 -W 1 "$host" 2>/dev/null)
    current_time=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [[ $ping_result == *"1 received"* ]]; then
        # Extract ping time
        time_ms=$(echo "$ping_result" | grep "time=" | awk -F'time=' '{print $2}' | awk '{print $1}')
        
         if [[ $time_ms > 100 ]]; then
            echo "[$current_time] High latency: $time_ms ms (exceeds 100 ms)"
        else
            echo "[$current_time] Normal: $time_ms ms"
        fi
        fail_count=0
        
    else
        ((fail_count++))
        
        case $fail_count in
            1|2)
                echo "[$current_time] Warning ($fail_count/3): No response from $host"
                ;;
            3)
                echo "--------------------------------------------------"
                echo "[$current_time] CRITICAL FAILURE:"
                echo "Host $host unreachable for 3 consecutive attempts!"
                echo "--------------------------------------------------"
                fail_count=0
                ;;
        esac
    fi
    
    sleep 1
done

# Test note: Reserved IP 10.255.255.1 (RFC 1918) - guaranteed to fail all pings
# Use to validate failure detection logic (3 consecutive timeouts)

