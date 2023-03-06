import os

os.environ['LOKI_ADDR'] = 'http://localhost:3100'

os.system('logcli query \'{service="serviceName"} |= "login.preCheckEmail.fail" |= "ip"\'  --limit=500000 --since=721h -o raw > mylog.txt')


unique_ips = set()

with open('mylog.txt') as f:
    file_dict = {}
    for line in f:
        if "{" in line:
            file_dict = {}
            split_line = line.split("{")
            first_word = split_line[1]
            if "," in first_word:
                split_line2 = first_word.split(",")
                first_word2 = split_line2[0]
            for dict in first_word2:
                key, value = first_word2.split(':')
                # strip the whitespace
                key = key.strip()
                value = value.strip()
                # add the key, value pair to the dictionary
                file_dict[key] = value
            ip = file_dict.get('"ip"')
            if ip:
                ip = ip.strip('"')
                unique_ips.add(f"{ip}/32")

with open("out.txt", "w") as out:
    out.writelines(ip + '\n' for ip in unique_ips)

