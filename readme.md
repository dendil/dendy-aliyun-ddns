# 阿里云ddns
LANG : Python >= 3.6 ;
system : Centos7     ;

拉取代码
```
yum install -y git python3 python3-pip  jq sed 
cd /opt
git clone https://github.com/dendil/dendy-aliyun-ddns.git
```
安装依赖
```bash
cd dendy-aliyun-ddns 
need python >=3.7
python3  -m pip install --upgrade pip setuptools

python3  setup.py  install
```

自定义域名 二级域名  （脚本逻辑：每次向多个提供查询ip的网站请求自己的外网IP，并记录对比公网IP ，发现变更后进行重新解析）
```bash
/opt/dendy-aliyun-ddns/alddns.sh 40~44 行
.......                                                                          一级域名↓    次级域名头    解析类型
                /usr/bin/python3  /opt/alibabacloud_sample/sample.py  cn-shenzhen  $ip  example.com     @            A
                /usr/bin/python3  /opt/alibabacloud_sample/sample.py  cn-shenzhen  $ip  example.com     www          A
....
```
自定义自己的 AK SK  （获取方法控制台鼠标悬停右上角头像 `AccessKey 管理`）.
```python
/opt/dendy-aliyun-ddns/alibabacloud_sample/sample.py  29~31 行
        #config.access_key_id = EnvClient.get_env('ACCESS_KEY_ID')
        config.access_key_id = 'your_AK'
        # 您的AccessKey Secret
        #config.access_key_secret = EnvClient.get_env('ACCESS_KEY_SECRET')
        config.access_key_secret = 'your_SK'
```

托管 crontab 每10分钟刷新一次 
```bash
echo '# aliyun ddns scripts '       >> /var/spool/cron/root
echo '*/10 * * * * /opt/dendy-aliyun-ddns/aliddns.sh' >> /var/spool/cron/root

```



脚本仅实现简单功能 