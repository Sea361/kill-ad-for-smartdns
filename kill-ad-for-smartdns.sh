#!/bin/sh

# ver 1.1

# 判断文件是否大于2MB，大于则退出脚本
if [ -f /tmp/etc/smartdns/kill-ad-for-smartdns.conf ]; then
  filesize=$(du -k /tmp/etc/smartdns/kill-ad-for-smartdns.conf | awk '{print $1}')
  if [ "$filesize" -gt 2048 ]; then
    echo "文件超过2MB，退出脚本。"
    exit 0
  fi
fi

wget --no-check-certificate -c --tries=0 -P /tmp/etc/smartdns https://anti-ad.net/anti-ad-for-smartdns.conf
wget --no-check-certificate -c --tries=0 https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts -O /tmp/etc/smartdns/hosts_jdlingyu
wget --no-check-certificate -c --tries=0 https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts.txt -O /tmp/etc/smartdns/hosts.txt_VeleSila
wget --no-check-certificate -c --tries=0 https://raw.githubusercontent.com/Goooler/1024_hosts/master/hosts -O /tmp/etc/smartdns/hosts_Goooler

cat /tmp/etc/smartdns/hosts_jdlingyu >> /tmp/etc/smartdns/hosts_temp
cat /tmp/etc/smartdns/hosts.txt_VeleSila >> /tmp/etc/smartdns/hosts_temp
cat /tmp/etc/smartdns/hosts_Goooler >> /tmp/etc/smartdns/hosts_temp

sed -i 's/\r//' /tmp/etc/smartdns/hosts_temp
grep "^127" /tmp/etc/smartdns/hosts_temp > /tmp/etc/smartdns/hosts.temp
sed -i 's/127.0.0.1 /address \//g;s/$/&\/#/g' /tmp/etc/smartdns/hosts.temp
cat /tmp/etc/smartdns/anti-ad-for-smartdns.conf >> /tmp/etc/smartdns/hosts.temp
grep "^address" /tmp/etc/smartdns/hosts.temp > /tmp/etc/smartdns/hosts
rm /etc/smartdns/address.conf
rm /tmp/etc/smartdns/kill-ad-for-smartdns.conf
sort -n /tmp/etc/smartdns/hosts | uniq >> /tmp/etc/smartdns/kill-ad-for-smartdns.conf.bak
sed -i '1 iaddress /time.android.com/111.230.50.201' /tmp/etc/smartdns/kill-ad-for-smartdns.conf.bak
grep -vE '/360\.cn|www\.360\.cn' /tmp/etc/smartdns/kill-ad-for-smartdns.conf.bak > /tmp/etc/smartdns/kill-ad-for-smartdns.conf
sed -i '/livew.l.qq.com/d; /t7z.cupid.iqiyi.com/d; /wxsnsdy.wxs.qq.com/d' /tmp/etc/smartdns/kill-ad-for-smartdns.conf
ln -s /tmp/etc/smartdns/kill-ad-for-smartdns.conf /etc/smartdns/address.conf
ln -s /tmp/etc/smartdns/ /tmp/upload/

rm /tmp/etc/smartdns/hosts
rm /tmp/etc/smartdns/hosts.temp
rm /tmp/etc/smartdns/hosts.txt_VeleSila
rm /tmp/etc/smartdns/hosts_Goooler
rm /tmp/etc/smartdns/hosts_jdlingyu
rm /tmp/etc/smartdns/hosts_temp
rm /tmp/etc/smartdns/anti-ad-for-smartdns.conf
rm /tmp/etc/smartdns/kill-ad-for-smartdns.conf.bak

/etc/init.d/smartdns restart
