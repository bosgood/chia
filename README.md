# chia

Chia farmer infrastructure for AWS

## Description

From the [website](https://github.com/Chia-Network/chia-blockchain):
Chia is a modern cryptocurrency built from scratch, designed to be efficient, decentralized, and secure. Here are some of the features and benefits:

## What this repo is

This repo contains deployment configuration and infrastructure-as-code for
deploying systems designed to farm Chia.

This repo is still in its early stages,
so don't expect it to be 1-click or extremely easy to set up.

## Customization

This is a public repo, but it's being used to instantiate private infrastructure in AWS.
So, some information is necessarily gitignored.
In the `terraform/` directory, you must provide your own configuration via:

1. In `*.private.tfvars` files, define the following variables:

  ```
  availability_zone
  ssh_key_name
  ssh_public_key
  home_ips
  ```

2.  In `*.private.tf` files, define your AWS Terraform provider and any desired statefile backend, e.g.:

  ```terraform
  terraform {
    backend "s3" {
      bucket  = "your-tf-state"
      key     = "terraform.tfstate"
      region  = "us-east-1"
      encrypt = true
    }
  }

  provider "aws" {
    region = "us-east-1"
  }
  ```

## Deployment

1. [Download Terraform](https://www.terraform.io/downloads.html)
2. Ensure your AWS credentials are configured properly, via `aws configure`.
3. From the `terraform/` directory, run `terraform apply`. Pass in any tfvars files with `-var-file=...`.
4. Once the instance is provisioned, find its DNS name and connect to it:

  ```console
  $ aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"
  $ ssh ec2-user@your-instance-dns
  ```

5. From the instance, perform the following steps to setup the environment:

  ```console
  # Security updates
  [ec2-user@ip-10-0-0-23 ~]$ sudo su -
  [root@ip-10-0-0-23 ~]# yum update -y

  # Dependencies
  [root@ip-10-0-0-23 ~]# yum install docker htop tmux -y
  [root@ip-10-0-0-23 ~]# systemctl start docker

  # Format the EBS volumes
  [root@ip-10-0-0-23 ~]# mkdir /mnt/scratch /mnt/plot1
  [root@ip-10-0-0-23 ~]# mkfs.xfs /dev/nvme1n1
  [root@ip-10-0-0-23 ~]# mkfs.xfs /dev/nvme2n1
  [root@ip-10-0-0-23 ~]# mount -t xfs /dev/nvme1n1 /mnt/scratch
  [root@ip-10-0-0-23 ~]# mount -t xfs /dev/nvme2n1 /mnt/plot1
  ```

6. Start a Docker container with the chia-blockchain runtime environment.

  ```
  [root@ip-10-0-0-23 ~]# docker run --rm -it --entrypoint=/bin/bash --volume=/mnt/scratch:/mnt/scratch --volume=/mnt/plot1:/mnt/plot1 bosgood/chia:dev
  root@059bbf1b2ac6:/usr/local/chia-blockchain# chia init
  root@059bbf1b2ac6:/usr/local/chia-blockchain# chia keys generate
  # Copy the mnemonic key phase this command outputs, and either write it down or save it in a password vault somewhere
  ```

7. Create a Chia plot using the scratch space `/mnt/scratch`, with a final directory of `/mnt/plot1`:

  ```
  root@059bbf1b2ac6:/usr/local/chia-blockchain# chia plots create -k 35 --tmp_dir /mnt/scratch --final_dir /mnt/plot1
  ```

7. TODO: Finally, start the service

## Notes

* The CoreOS configuration is experimental and not currently in use.
* The Dockerfile is already being built and published to `bosgood/chia:dev`, so it isn't necessary for you to re-publish unless you want to customize it.

## License

This software is provided without any warranty.
Please see the [`LICENSE`](./LICENSE) for more information.
