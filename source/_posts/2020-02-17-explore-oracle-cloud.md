---
title: Explore Oracle Cloud Free tier
categories:
  - notes
tags:
  - code
typora-root-url: ..
date: 2020-02-17 14:26:49
updated: 2020-02-17 14:26:49
---

# Introduction

As said on oracle's website, There are several always free benefits for a free tier user account. [1] 

> ### What are Always Free cloud services?
>
> ##### Databases
>
> Your choice of Autonomous Transaction Processing or Autonomous Data Warehouse. 
>
> 2 databases total, each with 1 OCPU and 20 GB storage.
> 
> ##### Compute
>
> 2 virtual machines with 1/8 OCPU and 1 GB memory each.
> 
> ##### Storage
>
> 2 Block Volumes, 100 GB total. 10 GB Object Storage. 10 GB Archive Storage.
>
> ##### Additional Services
>
> Load Balancer: 1 instance, 10 Mbps bandwidth. 
>
> Monitoring: 500 million ingestion datapoints, 1 billion retrieval datapoints. 
>
> Notifications: 1 million sent through https per month, 1,000 sent through email per month.
>
> Outbound Data Transfer: 10 TB per month.

# Register

In order to use their services, a validate bank card is required, although on the website it says a credit card is necessary, but a 
debit card is also effective. During the account registering, it will ask you about the home region setting.

[![Oracle Region Overview][image-1]](https://www.oracle.com/cloud/data-regions.html)

You may want to choose one that is near you geographically. 
Some people said that the free slots might be full on some popular regions,
I chose EMEA-UK South, which is working good.

After applying for an account, it takes some seconds for the oracle system to setup your account credentials and workspace.
Then an email will be sent to you saying that your account is ready.

Congrats! Finally we can start our journey on exploring the real oracle cloud world.

# Create an Instance

In the left-side navigator, goto `compute > Instances`, hit the `Create Instance` button.

At first choose an image source that match your taste. After that, you may want to hit `Show Shape, Network and Storage Options`
 to change the Boot Volume from default 46.6GB to 100GB, which is the maximum volume that we are allowed to use. 
Then add your SSH key, choosing the `.pub` key file from your computer.

> **TIP:** in `Shown Advanced Options > Networking > Hostname`, you can set up a preferred hostname instead of the boring long default one. 

We can hit on `Create` to let oracle preparing our instance now.

# Login to the Instance

Based on my experience, you need to login as ubuntu / opc on a Ubuntu / CentOS image source.

A quick reference of the command: `$ ssh -l the/path/of/your/private/key <username>@<ip address>` 
 
## Allow to login as the root account

After logged in, the first thing you may want to do is allowing the ssh login of root account.
Switched to root user, and just input `vi ~/.ssh/authorized_keys`, and delete the very first line, which is something looks like:

```text
no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"ubuntu\" rather than the user \"root\".';echo;sleep 10" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEFYU...
```

# Manage the connectivity

### Allow the come-in traffic

In the Oracle Cloud Console, go to `Instances > View instance details`, in Instance Information part, click on the Virtual Cloud Network link.
Then select `Security Lists` on the Resources column, 
In `Ingress Rules`, open the rule detail that you want to make modification, e.g. `Ingress Rule 1`, change the `DESTINATION PORT RANGE` from default `22` to empty.  

### Remove the firewall

SSH into the Instance, switch to root user, and input this in the console:
```shell script
apt purge netfilter-persistent && reboot    # purge: remove package and configuration
```

### Preserve or change ip address

In the Oracle Cloud Console, go to `Instances > View instance details`, find `Attached VNICs` in
the Resources column. Then go `View VNIC detials > IP Addresses > Edit`.

Select `RESERVED PUBLIC IP` to preserve the current IP address.

To gain a new IP: select `NO PUBLIC IP` first, then reselect the option you prefer.

# Conclusion

After these steps, the instance is well prepared to do anything you want. 
For example, you may want to bind a domain or subdomain to this server, or deploying a certificate.

Then, a productive personal used instance is good to go.
This is my system situation, with a full Ubuntu 18.04 image source after installing apache and docker.

```text
  System load:  0.0               Processes:              112
  Usage of /:   2.1% of 96.75GB   Users logged in:        1
  Memory usage: 39%               IP address for ens3:    10.0.0.6
  Swap usage:   0%                IP address for docker0: 172.17.0.1
```

#### Block Storage, File Storage and Object Storage
A question should be wrote down, it is about what's the difference of these
3 storage mechanisms.

Based on the findings on the website, I think the essential difference is the communication protocol,
which is designed, or to say, used for different aims.

- for block storage, the direct interaction between user and hardware is established, user can directly operate on the raw byte data. 
Although, most of the time we will format it with a particular powerful and user-friendly file system.
- for file storage, the direct interaction between user and hardware is hidden. User operates on the provided file systems, accessing
path tree, folders, write and save files.
- for object storage, the concepts of path tree, folders or even files are all gone, the only concept left is object. User operates
the storage by REST API, GET/POST/PUT/DELETE, or other protocols that just like what you can used to operate objects.



[1]: https://www.oracle.com/ie/cloud/free/#always-free
[image-1]: /images/oracle-region.png
