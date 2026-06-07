#!/bin/bash

INPUT_FILE="subnets.txt"

OUTPUT_FILE="ipv4.txt"
TOP_20_FILE="top20_ips.txt"
> "$OUTPUT_FILE"
> "$TOP_20_FILE"

echo "Downloading the CIDRs..."
curl "https://www.cloudflare.com/ips-v4/" -o "$INPUT_FILE"

echo "Scanning for latency (this might take a while)"

while IFS= read -r subnet; do
    if [[ -z "$subnet" ]]; then
        continue
    fi

    echo "Scanning: $subnet"
    fping -C 4 -r 0 -t 200 -g "$subnet" 2>&1 | sed '/-/d' | sed -E 's/ : ([0-9.]+).*/ \1/' >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo "The scan has been finished, sorting for the best ones..."
sort -k2 -n "$OUTPUT_FILE" | head -n 20 > "$TOP_20_FILE"

echo "Done! The top 20 IPs have been saved to $TOP_20_FILE"
