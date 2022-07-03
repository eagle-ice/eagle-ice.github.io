---
layout: post
title: ubuntu_Kylin 安装之后的几件事
tags:
- tools
- VMPlayer
categories: Software Linux
description: 这是一些说明
---
系统新装之后基础软件的安装

## 1. 切换HOME

因为我用的是虚拟机希望每一套虚拟机都采用同样的配置所以需要单独一个home.vmdk 的盘来作为一个单独使用的东东以方便后续使用
我用的虚拟机是VMPlayer 就只说一下VMplayer的方法

![image-20220616225911110](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616225911110.png)

![image-20220616225959578](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616225959578.png)

![image-20220616230122701](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616230122701.png)

![image-20220616230151286](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616230151286.png)

![image-20220616230216104](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616230216104.png)

![image-20220616230246602](https://eagle-ice-blog.oss-cn-guangzhou.aliyuncs.com/img/image-20220616230246602.png)

创建好之后需要进入系统将当前的/home 替换为新生成的home(一块新的硬盘)

### 1.0 格式化新增的盘

进入虚拟机通过`$ sudo fdisk -l `查看当前都有那些硬盘`Disk /dev/sdb`
然后通过`$ sudo mkfs.ext4 /dev/sdb `格式化之后再使用`$ sudo fdisk -l` 查看

```
Disk /dev/sdb: 500 GiB, 536870912000 bytes, 1048576000 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

### 1.1 查找UUID

#### 方法1

进入虚拟机通过blkid
`$ sudo blkid` 此时会有如下输出

```
/dev/sda5: UUID="71ac33da-7354-4ba7-97f6-696a860cbc79" TYPE="ext4" PARTUUID="25dd2158-05"
/dev/sda1: UUID="D686-0261" TYPE="vfat" PARTUUID="25dd2158-01"
/dev/sdb: UUID="87df60e5-7fd9-4132-a133-e8ede71eed85" TYPE="ext4"
```

可以看到当前的/dev/sdb 就是我们需要挂载的盘

#### 方法2

如果`$ sudo blkid` 无法查到就需要通过 `ls -l /dev/disk/by-uuid`

```
lrwxrwxrwx 1 root root 10 3月   6 23:18 71ac33da-7354-4ba7-97f6-696a860cbc79 -> ../../sda5
lrwxrwxrwx 1 root root  9 3月   6 23:18 87df60e5-7fd9-4132-a133-e8ede71eed85 -> ../../sdb
lrwxrwxrwx 1 root root 10 3月   6 23:18 D686-0261 -> ../../sda1
```

### 1.2 修改home目录的挂在位置

打开`/etc/fstab` `$ sudo vim /etc/fstab`, 在最后增加一行
`UUID=87df60e5-7fd9-4132-a133-e8ede71eed85 /home          ext4 defaults 1 1` 其中UUID 和刚才找到的UUID对应， 这样就能保证下次开机这个盘挂载在/home 目录

### 1.3 将当前/home 中的信息复制到新的盘,要是第一次不复制可能导致下次开机无法正常登陆

* `sudo mount /dev/sdb /mnt`
* `sudo cp -rfP /home/* /mnt/` 带权限复制

经过上面的步骤之后，下次重新开机就会看到原本的home已经被新盘替代
`$ mount |grep home`

`/dev/sdb on /home type ext4 (rw,relatime)`

## 2. 换源

做完上面操作就准备开始换源：

### 2.1 图形化换源

> [Wiki，源列表](https://wiki.ubuntu.org.cn/%E6%BA%90%E5%88%97%E8%A1%A8)

