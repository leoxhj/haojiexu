# K8s on Raspbian Lite

以下教程为在树莓派上创建K8s集群

## 前提条件：

* 准备2块以上Raspberry Pi 2， 3
* 安装raspbian stretch系统到Raspberry Pi


## 安装Raspbian Stretch 
* 刷入raspbian lite到SD卡
img下载地址： [raspbian lite](http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-12-01/)
用Etcher工具 [Etcher.io](http://etcher.io) 刷入系统.

* 修改主机名
使用以下命令修改主机名，比如我的master node名为leoboss1
```
$ raspi-config
```

## 安装Kubernetes - Master && Worker node

### Master && Worker都需要以下步骤
* 安装最新版本 Docker - 17.11.0-ce for Jessie

```
$ curl -sSL get.docker.com | sh && \
sudo usermod pi -aG docker
```

* 关闭 swap - 对于Kubernetes 1.7以上版本，swap开启的话会有报错。

```
$ sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove
```

* 修改文件 `/boot/cmdline.txt`，在文件末尾追加以下内容（注意：不要另起新行）

```
cgroup_enable=cpuset cgroup_enable=memory
```

* 重启（修改cmdline.txt后必须重启才能生效）
```
$ reboot
```

* 安装kubeadmin

```
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm

```
### Master node only
* 初始化 master node：
if you are using wi-fi network, you will need add below --apiserver-advertise flag
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.2.200
```

Note： 这一步大概需要15分钟左右时间，先坐下来喝杯咖啡。

After the `init` is complete run the snippet given to you on the command-line：

pi@leoboss1:~ $ sudo kubeadm init
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[init] Using Kubernetes version: v1.8.4
[init] Using Authorization modes: [Node RBAC]
[preflight] Running pre-flight checks
[preflight] WARNING: docker version is greater than the most recently validated version. Docker version: 17.11.0-ce. Max validated version: 17.03
[kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [leoboss1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.2.200]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "scheduler.conf"
[controlplane] Wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
[controlplane] Wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
[controlplane] Wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
[init] Waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
[init] This often takes around a minute; or longer if the control plane images have to be pulled.
[apiclient] All control plane components are healthy after 370.516204 seconds
[uploadconfig] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[markmaster] Will mark node leoboss1 as master by adding a label and a taint
[markmaster] Master leoboss1 tainted and labelled with key/value: node-role.kubernetes.io/master=""
[bootstraptoken] Using token: 482c94.74f12081feff76e6
[bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: kube-dns
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run (as a regular user):

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  http://kubernetes.io/docs/admin/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token f27f3d.5fa72f3473925936 192.168.2.200:6443 --discovery-token-ca-cert-hash sha256:8781001e645600a3be221a6555921493966687e01bc94d2bc10861f3af8b01e1


```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Finally, we need to setup flannel v0.7.1 as the Pod network driver. Do not use v0.8.0 due to a known bug that can cause a CrashLoopBackOff error. Run this on the master node:

$ curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel-rbac.yml | kubectl create -f -
$ curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel.yml | sed "s/amd64/arm/g" | kubectl create -f -

This step takes the key generated for cluster administration and makes it available in a default location for use with `kubectl`.

* Now save your join-token

Your join token is valid for 24 hours， so save it into a text file. Here's an example of mine：

```
kubeadm join --token 4cd7b6.c88687d790db6e9f 192.168.2.200:6443 --discovery-token-ca-cert-hash sha256:659e484ee6c292864443428b8238cd7be73fa7a2fb4f886a9c6cc58b8b18deb1```

* Check everything worked：

```
$ kubectl get pods --namespace=kube-system
NAME                           READY     STATUS    RESTARTS   AGE
etcd-of-2                      1/1       Running   0          12m
kube-apiserver-of-2            1/1       Running   2          12m
kube-controller-manager-of-2   1/1       Running   1          11m
kube-dns-66ffd5c588-d8292      3/3       Running   0          11m
kube-proxy-xcj5h               1/1       Running   0          11m
kube-scheduler-of-2            1/1       Running   0          11m
weave-net-zz9rz                2/2       Running   0          5m
```

You should see the "READY" count showing as 1/1 for all services as above. DNS uses three pods， so you'll see 3/3 for that.

* Setup networking

Install Weave network driver

```
$ kubectl apply -f https://git.io/weave-kube-1.6
```

### Join other nodes

On the other RPis， repeat everything apart from `kubeadm init`.

* Change hostname

Use the `raspi-config` utility to change the hostname to k8s-worker-1 or similar and then reboot.

* Join the cluster

Replace the token / IP for the output you got from the master node：

```
### Worker node only
* Worker node加入
```
$ sudo kubeadm join --token 1fd0d8.67e7083ed7ec08f3 192.168.0.27：6443
```

You can now run this on the master：

```
$ kubectl get nodes
NAME      STATUS     AGE       VERSION
k8s-1     Ready      5m        v1.7.4
k8s-2     Ready      10m       v1.7.4
```


## Deploy a container

*function.yml*

```
apiVersion： v1
kind： Service
metadata：
  name： markdownrender
  labels：
    app： markdownrender
spec：
  type： NodePort
  ports：
    - port： 8080
      protocol： TCP
      targetPort： 8080
      nodePort： 31118
  selector：
    app： markdownrender
---
apiVersion： apps/v1beta1 # for versions before 1.6.0 use extensions/v1beta1
kind： Deployment
metadata：
  name： markdownrender
spec：
  replicas： 1
  template：
    metadata：
      labels：
        app： markdownrender
    spec：
      containers：
      - name： markdownrender
        image： functions/markdownrender：latest-armhf
        imagePullPolicy： Always
        ports：
        - containerPort： 8080
          protocol： TCP
```

Deploy and test：

```
$ kubectl create -f function.yml
$ curl -4 http://localhost：31118 -d "# test"
<p><h1>test</h1></p>
```

From a remote machine such as your laptop use the IP address of your Kubernetes master and try the same again.

## Start up the dashboard

This is the development dashboard which has TLS disabled and is easier to use.

```
$ curl -sSL http://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard-arm.yaml | kubectl create -f -
```

You can then find the IP and port via `kubectl get svc -n kube-system`. To access this from your laptop you will need to use `kubectl proxy`.

## Remove the test deployment

Now on the Kubernetes master remove the test deployment：

```
$ kubectl delete -f function.yml
```

### Moving on

Now head back over to the tutorial and deploy OpenFaaS