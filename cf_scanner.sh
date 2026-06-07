#!/bin/bash

INPUT_FILE="subnets.txt"

OUTPUT_FILE="ipv4.txt"
TOP_20_FILE="top20_ips.txt"

# clear old ones
> "$OUTPUT_FILE"
> "$TOP_20_FILE"

echo "Downloading the CIDRs..."
curl -s "https://www.cloudflare.com/ips-v4/" -o "$INPUT_FILE"

echo "Scanning 50 random IPs for each subnet (Super Fast!)..."

while IFS= read -r subnet; do
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

echo "Done! The top 20 IPs have been saved to $TOP_20_FILE"
