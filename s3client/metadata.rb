maintainer       "John E. Vincent"
maintainer_email "lusis.org+github.com@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures client to download files from aws using aws-s3"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3"

recipe "s3client::default", "Installs all the dependencies to use the s3client"


depends "apt"
