# dh-brave-ec2LinuxBuild
Automates a brave-browser build within Ubuntu Linux deployed to AWS EC2 using Terraform.

## Terraform

### main.tf

A simple EC2 deployment consisting of a security group allowing SSH ingress to an EC2 instance with a sizeable root block device for building Brave.

AWS instance is brought up with a `~/.npmrc` file and `~/user_data.sh` script. Values for `~/.npmrc` can be defined in `terraform.tfvars`.

The final step is a remote-exec to run the user_data.sh Bash script in a screen which upgrades Ubuntu, installs build dependencies, initializes npm and runs the build resulting in binary packages at `~/brave-browser/src/out/Release/*.{rpm|deb}`.


```
ubuntu@dh-brave-ec2-LinuxBuild:~$ ls ./brave-browsersrc/out/Release/ | egrep '(deb|rpm)$'
brave-browser-1.28.71-1.x86_64.rpm
brave-browser_1.28.71_amd64.deb
```

### terraform.tfvars

Assign AWS instance_size and root_volume_size. Default values are t2.micro and 8GiB volume, intended for free tier, and will fail the actual build. Recommended settings a c5.9xlarge with at least 100GiB for the root_volume_size.

The build for brave-browser depends on some additional variables being set in an ~/.npmrc file, so those can be set here as well. Default values are placeholders to allow a build to run.
