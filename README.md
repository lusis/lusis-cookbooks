**I am currently in the process of migrating my cookbooks over to an organization so that they are easier for people to use with the `knife github` plugin. 

You can find the repo [here](https://github.com/lusis-cookbooks). I'll update each cookbook with a pointer as soon as it's moved***

# Lusis Cookbooks for Chef
The following are various cookbooks created for [opscode chef](http://opscode.com).

**Please do not blindly use these cookbooks without reading them carefully. They are somewhat tuned to the specific needs of my employer. Your best bet is to use them, where appropriate, as a foundation for creating your own cookcooks**

## Chef cookbook
This is a modification of the existing opscode chef cookbook used for, among other things, bootstraping new nodes.

### Notes/Changes
The changes made to this cookbook were mainly for making it more palatable on Redhat variants. This includes:
 * changing the init method to 'init' for RHEL variants
 * cleaning up the client\_service.rb for RHEL variants

## Voldemort cookbook
This is a "from-scratch" cookbook for getting a single-node Voldemort server up and running. It requires a cookbook called jdk which will be up to you to create/import/hack for getting a jdk on your server. Most of the basics are configurable so you can see how you might use the attributes to configure partitioning, schemas, storage layouts and such.

## JDK cookbook
This is a highly modified fork of Seth Chisamore's official opscode Java cookbook. It was converted to allow for Sun JDK support under RHEL variants instead of OpenJDK, which sadly, is not viable for production servers where performance counts.

### Notes/Changes
In the files/default directory, I've touched 4 files (2 RPMS and 2 bin files). You'll want to replace those with the Oracle JDK installer files. This *WILL* bloat your cookbook as these files are large. Alternately, you can populate a local Yum repo with the RPMs and install from there.

## S3Client cookbook
This is a hack of the awsclient cookbook provided by Sonian. The original Sonian awsclient cookbook used the awesome 'fog' gem. However, that doesn't work on the ELFF ruby 1.8.6 RPM for some reason. I've opened a bug report on it. I ported it to use the official amazon aws-s3 gem (the sameone paperclip uses). I've also renamed the resource to be s3\_file instead of remote\_s3\_file in the sonian cookbook to prevent conflicts. Otherwise it behaves exactly the same.

### Notes/Changes
I make NO claims about the viability of the technique used to provide the s3\_file resource. I simply followed the Sonian cookbook which appears to clobber the Chef namespace pretty heavily. I looked at converting it to be an LWRP but decided that the current way works cleanly enough for my needs.
One thing I'd REALLY like to do is add checksum support via the ETAG MD5 sum provided by S3 however I didn't feel like clobbering the checksum method to use MD5 instead of SHA1 right now.

## databag\_decrypt and decrypt\_test
databag\_decrypt is a reference implementation of encrypted databag items. It requires a specific format for the databag item and supporting rake tasks in your chef-repo directory.

decrypt\_test is an example cookbook with instructions to verify that it works

### Notes
The rake tasks are available here:

https://gist.github.com/742575

Make a directory in your repo called "tasks" if it doesn't exist and put the `encrypt_databag_item.rake` file in it.
Add the following to the end of your rake file:

	load File.join(TOPDIR, 'tasks','encrypt_databag_item.rake')

Read the instructions in the decrypt\_test directory for more details.


# License
All of these cookbooks are licensed under the Apache License, version 2.0. Should any file be missing said license header, please feel free to assume the afore mentioned Apache License is applicable to those files.

# Forks
I'm glad to accept patches to these cookbooks from forks however these are pretty opinionated about things and specific to my employer's needs. Don't take it personally if I don't merge the changes back in.

