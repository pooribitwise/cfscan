# Cloudflares clean ip finder
The most common way in the countries in which internet is restricted, people hide their server IPs
behind the cloudflares cdn to make it impossible for the internet blocking system ban the main IP.
Goverments could not tolerate this bypassing and started restricting cloudflare's cdn IPs randomly
daily to make the cat and mouse game more difficult.
## Summary:
This scripts downloads the fresh netmasks in form of CIDR from cloudflares legitimate webpage using
curl. Stores the subnets in **subnets.txt**.
Then selects random 100 IPs for each subnet using nmap tool and starts pinging them four times with
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
4. View the result:
```bash
Downloading the CIDRs...
Scanning 50 random IPs for each subnet (Super Fast!)...
Scanning: 173.245.48.0/20
Scanning: 103.21.244.0/22
Scanning: 103.22.200.0/22
Scanning: 103.31.4.0/22
Scanning: 141.101.64.0/18
Scanning: 108.162.192.0/18
Scanning: 190.93.240.0/20
Scanning: 188.114.96.0/20
Scanning: 197.234.240.0/22
Scanning: 198.41.128.0/17
Scanning: 162.158.0.0/15
Scanning: 104.16.0.0/13
Scanning: 104.24.0.0/14
Scanning: 172.64.0.0/13
The scan has been finished, sorting for the best ones...
Speed test for top 20 IPs
Testing 190.93.246.109 (Ping: 78.2ms)...3.16 MB/s
Testing 162.159.8.164 (Ping: 78.9ms)...2.17 MB/s
Testing 104.19.135.61 (Ping: 79.0ms)...5.25 MB/s
Testing 104.18.136.246 (Ping: 79.4ms)...5.52 MB/s
Testing 104.24.207.182 (Ping: 79.5ms)...4.65 MB/s
Testing 190.93.245.206 (Ping: 79.9ms)...3.46 MB/s
Testing 104.21.64.30 (Ping: 80.3ms)...3.26 MB/s
Testing 173.245.49.89 (Ping: 80.4ms)...5.30 MB/s
Testing 104.27.37.48 (Ping: 81.0ms)...5.70 MB/s
Testing 104.25.126.182 (Ping: 81.3ms)...6.46 MB/s
Testing 162.159.26.145 (Ping: 81.4ms)...6.49 MB/s
Testing 188.114.99.8 (Ping: 81.6ms)...0.00 MB/s
Testing 173.245.49.119 (Ping: 81.8ms)...0.00 MB/s
Testing 104.27.46.37 (Ping: 82.1ms)...0.00 MB/s
Testing 141.101.113.199 (Ping: 82.1ms)...0.00 MB/s
Testing 104.19.7.189 (Ping: 82.4ms)...0.00 MB/s
Testing 104.25.126.81 (Ping: 82.4ms)...0.00 MB/s
Testing 190.93.245.221 (Ping: 82.4ms)...0.00 MB/s
Testing 198.41.214.98 (Ping: 82.6ms)...0.00 MB/s
Testing 172.65.3.228 (Ping: 82.8ms)...0.00 MB/s
Sorting final results by Download Speed...
Done! The top 20 IPs have been saved to best_ips_with_speed.txt
```
