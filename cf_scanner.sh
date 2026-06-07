#!/bin/bash

INPUT_FILE="subnets.txt"

OUTPUT_FILE="ipv4.txt"
TOP_20_FILE="top20_ips.txt"
FINAL_SPEED_FILE="best_ips_with_speed.txt"
FINAL_TABLE="final_top_ips.txt"

# clear old ones
> "$OUTPUT_FILE"
> "$TOP_20_FILE"
> "$FINAL_SPEED_FILE"
> "$FINAL_TABLE"

echo "Downloading the CIDRs..."
curl -s "https://www.cloudflare.com/ips-v4/" -o "$INPUT_FILE"

echo "Scanning 50 random IPs for each subnet (Super Fast!)..."

while read -r subnet; do
    if [[ -z "$subnet" ]]; then
        continue
    fi

    echo "Scanning: $subnet"

    # get random ips using nmap
    RANDOM_IPS=$(nmap -sL -n "$subnet" | awk '/Nmap scan report for/{print $5}' | shuf -n 50)

    # ping the ips and clean output
    fping -q -C 4 -r 0 -t 200 $RANDOM_IPS 2>&1 | grep -v "-" | awk '{print $1, $3}' >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo "The scan has been finished, sorting for the best ones..."
sort -k2 -n "$OUTPUT_FILE" | head -n 20 > "$TOP_20_FILE"

echo "Speed test for top 20 IPs"

while read -r IP PING; do
    echo -n "Testing $IP (Ping: ${PING}ms)...";

    # 25 MB in 5 secs test
    SPEED_BPS=$(curl -s --connect-timeout 2 --max-time 5 \
        --resolve "speed.cloudflare.com:443:$IP" \
        "https://speed.cloudflare.com/__down?bytes=25000000" \
        -o /dev/null -w "%{speed_download}")

    if [[ -z "$SPEED_BPS" || "$SPEED_BPS" == "0.000" ]]; then
        echo "Failed"
    else
        SPEED_MB=$(echo "$SPEED_BPS" | awk '{printf "%.2f", $1/1048576}')
        echo "$SPEED_MB MB/s"
        echo "$IP $PING $SPEED_MB" >> "$FINAL_SPEED_FILE"
    fi
done < "$TOP_20_FILE"

echo "Sorting final results by Download Speed..."
# creating fancy table
echo -e "IP Address      Ping      Download Speed" > "$FINAL_TABLE"
echo "------------------------------------------" >> "$FINAL_TABLE"
sort -k3 -n -r "$FINAL_SPEED_FILE" | awk '{printf "%-15s %-9s %-10s\n", $1, $2"ms", $3" MB/s"}' >> "$FINAL_TABLE"

echo "Done! The top 20 IPs have been saved to $FINAL_TABLE"
