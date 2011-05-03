default[:rpmbuild][:user] = "rpmbuild"
default[:rpmbuild][:gecos] = "RPM Build User"
default[:rpmbuild][:home_dir] = "/mnt/rpmbuild"
default[:rpmbuild][:build_dir] = "#{node[:rpmbuild][:home_dir]}/buildrpm"
default[:rpmbuild][:tmp_dir] = "#{node[:rpmbuild][:home_dir]}/tmp"
default[:rpmbuild][:additional_packages] = ['openssl-devel', 'openldap-devel', 'js-devel', 'libicu-devel', 'libtool', 'gnutls-devel', 'libidn-devel', 'libssh2-devel','nss-devel']
default[:rpmbuild][:packager] = "A User <shouldachangedthis@mydomain.com"
default[:rpmbuild][:vendor] = "My Fancy Company"
