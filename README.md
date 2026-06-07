# Cloudflares clean ip finder
The most common way in the countries in which internet is restricted, people hide their server IPs
behind the cloudflares cdn to make it impossible for the internet blocking system ban the main IP.
Goverments could not tolerate this bypassing and started restricting cloudflare's cdn IPs randomly
daily to make the cat and mouse game more difficult.
## Summary:
This scripts downloads the fresh netmasks in form of CIDR from cloudflares legitimate webpage using
curl. Stores the subnets in **subnets.txt**.
Then selects random 50 IPs for each subnet using nmap tool and starts pinging them four times with
200ms timeout. Then writes the sorted ips in **ipv4.txt** and the best 20 ones in **top20_ips.txt**.
In the next step, it tests the download speed of the top 20 pinged working IPs using curl and the
owns Cloudflare speed test page. Writes it results in **best_ips_with_speed.txt**.
## Usage:
1. Download the required packages:
....* For apt package manager:
```bash
sudo apt install fping nmap
```
....* For dnf package manager:
```bash
sudo dnf install fping nmap
```
2. Give the script executable permission:
```bash
chmod +x cf_scanner.sh
```
3. Run the script:
```bash
./cf_scanner.sh
```    
