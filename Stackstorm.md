# Stackstorm

## Actions
Actions are pieces of code which can perform arbitrary automation or remediation tasks in your environment. They can be written in any programming language.
To give you a better idea, here is a short list of tasks which can be implemented as actions:
```
restart a service on a server
create a new cloud server
acknowledge a Nagios / PagerDuty alert
send a notification or alert via email or SMS
send a notification to an IRC channel
send a message to Slack
start a Docker container
snapshot a VM
run a Nagios check
```
## Sensors
/opt/stackstorm/st2/bin/st2sensorcontainer --config-file=/etc/st2/st2.conf --sensor-ref=hello_st2.HelloSensor



## Commands
```
$st2ctl start|stop|restart|status
$service st2chatops start|stop
$st2 pack list
$st2 pack get examples
$st2 action list -p examples
$st2 action get examples.hello
$st2 action execute examples.hello
$st2 execution list
$st2 execution get 54fc83b9e11c711106a7ae01
$st2 run core.local cmd='ls -l'
$st2 run mypack.myaction parametername="value 1,value2,value3"
$st2 run core.remote hosts=localhost env='{"key1": "val1", "key2": "val2"}' cmd="echo ponies \${key1} \${key2}"
$st2 run core.remote hosts=localhost env="key1=val1,key2=val2" cmd="echo ponies \${key1} \${key2}"
$st2-apply-rbac-definitions --config-file=/etc/st2/st2.conf
$st2 apikey create -k -m '{"used_by": "CMP"}'
$st2 login st2admin -p "123456"
$htpasswd -s htpasswd hj_xu
$st2 run core.http method=POST body='{"you": "too", "name": "st2"}' url=https://localhost/api/v1/webhooks/sample headers='x-auth-token=c9fb0d5de5c64dbdbe49f9655733bec4,content-type=application/json' verify_ssl_cert=False
$st2 run core.http method=POST body='{"you": "too", "name": "st2"}' url=https://localhost/api/v1/webhooks/sample headers='st2-api-key=YjA1ODg2NGU4ZDJhZDgyM2Q1YzYzMzUzMTM4YTc0ZWUyNjgxZjgwZGU1NDQzZWYzMWEzNzMzN2I3NWQxMDBkMg,content-type=application/json' verify_ssl_cert=False
$st2 run core.http method=POST body='{"pool_id": 9301, "assigned_group": "上海-OPS-APP", "assignee": "cjie2"}' url=https://localhost/api/v1/webhooks/pooldecommission headers='st2-api-key=YjA1ODg2NGU4ZDJhZDgyM2Q1YzYzMzUzMTM4YTc0ZWUyNjgxZjgwZGU1NDQzZWYzMWEzNzMzN2I3NWQxMDBkMg,content-type=application/json' verify_ssl_cert=False
$st2 apikey list -dy --show-secrets > apikeys.yaml //[backup apikey](https://docs.stackstorm.com/authentication.html) 
$st2 apikey load apikeys.yaml //restore apikey from backup
$st2 execution list  -n 100|grep running|cut -d '|' -f 2 |cut -c3-50|xargs st2 execution cancel
$mistral execution-list|grep RUNNING |cut -d '|' -f2 |xargs mistral execution-delete


```

## Folders
### Logs
/var/log/st2
### Configuration
```
/etc/st2/st2.conf
/usr/share/doc/st2/conf/nginx/st2.conf
/etc/nginx/conf.d/
```
### Examples
/usr/share/doc/st2/examples
### Credentials
```angular2html
/etc/st2/htpasswd
```