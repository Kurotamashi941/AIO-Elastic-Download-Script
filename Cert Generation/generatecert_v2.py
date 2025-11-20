import subprocess
import re

def is_valid_ip(value):
    # Regular expression to check if a string is a valid IP address (IPv4)
    pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
    return re.match(pattern, value) is not None

def generate_req_conf(entries):
    # Extract country, state, locality, and organization from the first entry
    country, state, locality, organization = entries[0]
    
    for entry in entries[1:]:  # Start from the second entry onwards
        filename = f"{entry[0]}.req.conf"
        with open(filename, "w") as conf_file:
            conf_file.write("[req]\n")
            conf_file.write("default_bits = 2048\n")
            conf_file.write("distinguished_name = req_distinguished_name\n")
            conf_file.write("req_extensions = req_ext\n")
            conf_file.write("prompt = no\n\n")
            
            conf_file.write("[req_distinguished_name]\n")
            conf_file.write(f"countryName = {country}\n")
            conf_file.write(f"stateOrProvinceName = {state}\n")
            conf_file.write(f"localityName = {locality}\n")
            conf_file.write(f"organizationName = {organization}\n")
            conf_file.write(f"commonName = {entry[1]}\n\n")
            
            conf_file.write("[req_ext]\n")
            conf_file.write("basicConstraints = CA:FALSE\n")
            conf_file.write("keyUsage = digitalSignature, keyEncipherment, dataEncipherment\n")
            conf_file.write("extendedKeyUsage = serverAuth, clientAuth\n")
            conf_file.write("subjectAltName = @alt_names\n\n")
            
            conf_file.write("[alt_names]\n")
            
            # Add DNS and IP entries dynamically
            dns_count = 1
            ip_count = 1
            for value in entry[0:]:
                if is_valid_ip(value):  # Identify valid IP format
                    conf_file.write(f"IP.{ip_count} = {value}\n")
                    ip_count += 1
                else:  # Identify DNS
                    conf_file.write(f"DNS.{dns_count} = {value}\n")
                    dns_count += 1
            
        # Execute OpenSSL command securely
        openssl_command = [
            'openssl', 'req', '-new', '-out', f'{entry[0]}.csr',
            '-newkey', 'rsa:2048', '-nodes', '-sha256',
            '-keyout', f'{entry[0]}.key', '-config', filename
        ]
        try:
            subprocess.run(openssl_command, check=True)
            print(f"Generated certificate and key for: {entry[0]}")
        except subprocess.CalledProcessError as e:
            print(f"Error generating certificate for {entry[0]}: {e}")

def parse_inventory_file(filename):
    entries = []
    with open(filename, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                parts = line.split(':')
                entries.append(parts)
    return entries

filename = 'inventory.txt'
inventory_entries = parse_inventory_file(filename)

generate_req_conf(inventory_entries)
