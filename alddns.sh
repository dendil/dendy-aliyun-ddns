#!/bin/bash
ipwcn_ip=`curl --connect-timeout 5 -m 10 https://ipv4.ipw.cn/api/ip/myip`
if [ "${ipwcn_ip}" == "" ]; then
    httpbin_ip=`curl --connect-timeout 5 -m 10 "http://httpbin.org/get" |jq .origin|sed 's/\"//g'`
    if [ "${httpbin_ip}" == "" ]; then
        ip42pl_ip=`curl --connect-timeout 5 -m 10 https://ip.42.pl/raw`
        if [ "${ip42pl_ip}" == "" ]; then
                        jsonip_ip=`curl --connect-timeout 5 -m 10 "https://jsonip.com/"|jq .ip|sed 's/\"//g'`
                        if [ "${jsonip_ip}" == "" ]; then
                                ipify_ip=`curl --connect-timeout 5 -m 10 https://api.ipify.org/`
                                if [ "${ipify_ip}" == "" ]; then
                                        ifconfigme_ip=`curl --connect-timeout 5 -m 10 https://ifconfig.me/ip `
                                        if [ ! "${ifconfigme_ip}" == "" ]; then
                                                ip=${ipify_ip}
                                        fi
                                else
                                        ip=${ipify_ip}
                                fi
                        else
                                ip=${jsonip_ip}
                        fi
                else
                        ip=${ip42pl_ip}
                fi
    else
      ip=${httpbin_ip}
    fi
else
    ip=${ipwcn_ip}
fi

if [ ! -f  /var/log/ddnsip_log ]; then
        touch /var/log/ddnsip_log
fi
old_ip=`cat /var/log/ddnsip_log`
echo "i do" > /var/log/ddnsip2_log
if [ ! "$ip" == "" ];then
        if [ "$ip" == "$old_ip" ];then
                echo "ip no change"
        else
                /usr/bin/python3  /opt/alibabacloud_sample/sample.py  cn-shenzhen  $ip  potantun.top @  A
                /usr/bin/python3  /opt/alibabacloud_sample/sample.py  cn-shenzhen  $ip  potantun.top www  A
                echo $ip > /var/log/ddnsip_log
        fi
fi
