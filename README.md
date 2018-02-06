# Filelocker

#### Table of Contents

1. [Description](#description)
    * [Scope](#scope)
2. [Setup - The basics of getting started with this module](#setup)
    * [What this module touches](#what-this-module-touches)
    * [Setup requirements](#setup-requirements)
    * [Beginning with this module](#beginning-with-this-module)
3. [Usage](#usage)
4. [Reference](#reference)
6. [Development](#development)

## Description

"Filelocker is a web based secure file sharing application that facilitates easy file sharing between users at an organization and promotes secure data sharing habits." -[Filelocker site](http://filelocker2.sourceforge.net/)

This module installs, configures, and manages the filelocker service on Linux. Filelocker is written in python 2.7 and serves its pages using CherryPy out of the box.

### Scope

This module does not create the database or database user.

This module does not configure a production-ready webserver, nor does it set up reverse-proxying to front for Filelocker's CherryPy server. This is up to you and your webserver of choice, though this README will provide some pointers for Apache.

It does not manage dependencies for Filelocker. This is the domain of packaging, though this module does support installing Filelocker from git and will provide some pointers for the manual steps required when doing so.

It does not install, configure, or manage an antivirus service. Note: Filelocker by default is configured to use the command 'clamscan' but neither this module nor Filelocker itself provide the antivirus service.

## Setup

### What this module touches

* The install directory for the application itself
* The vault directory (optional)
* The specified database, for:
    - Initialization of Filelocker database (optional)
    - Creation of Filelocker Admin account in the database (optional)
    - Writing configuration options to the database

### Setup requirements

For best results, create the filelocker database and grant the filelocker user full access to it BEFORE running the module.

Once the DB, user, and grants are created, table initialization,configuration, and the creation of an admin user can optonally be taken care of by this module. But if you do not take advantage of this, here are the manual steps:
``` shell
# Initialize the filelocker DB (which you have already created and granted) and create admin user
python ${install_dir}/setup.py -i

# Configure filelocker and run the service (with this module)
puppet agent ...
```

### Beginning with this module

To have puppet install Filelocker with the default parameters, you will at minimum need to supply some required arguments:

``` puppet
class { 'filelocker':
  admin_pass => '***',
  dbpassword => '***',
  dbhost     => 'db.domain.tld',
}
```

Declared this way the module:

1. Ensures the existence of the vault directory at `/vault` and sets ownership exclusive to the filelocker user and group.
2. Installs the filelocker package from your system's repositories by the default provider for your system. If your are not provided with this package, this module supports install from git as well.
3. Creates filelocker.conf in `${install_dir}/etc` to defaults in combo with your required arguments.
4. Initializes the database tables (first run only).
5. Creates the admin user (first run only).
6. Creates `${install_dir}/.my.cnf` with DB credentials and ownership exclusive to the filelocker user and group.
7. UPDATEs database config options according to defaults.
8. Starts the filelocker service.

## Usage

All of the file- and DB-based config options are managed by this module.
If you wind up configuring some things within the web gui and wish to get these changes into puppet, it is easy to turn this into a YAML hash for Hiera on the cli so the configuration can then in the future be managed by puppet. Try something like this, substituting your particulars:

``` shell
mysql -u filelocker -p -h filelocker.domain.tld --execute="select name, value from config;" -B filelocker  | sed "s/\t/: '/g"  | sed "s/\(^.*\)\t\(.*$\)/filelocker::\1: '\2'/g"
```

### Antivirus

Filelocker's default is to scan every uploaded file with clamscan before accepting an upload.

To skip virus scan of uploads, you can provide an empty string for the param `$antivirus_command`.

``` puppet
class { 'filelocker':
  admin_pass        => '***',
  dbpassword        => '***',
  dbhost            => 'db.domain.tld',
  antivirus_command => '',
}
```

### Git install

You may not have integrated Filelocker into your packaging system, so the module also supports git install and can create the `$install_dir` and clone the specified repo into it.

``` puppet
class { 'filelocker':
  admin_pass        => '***',
  dbpassword        => '***',
  dbhost            => 'db.domain.tld',
  package_provider  => 'git',
  package_source    => '<git repo uri here>',
}
```

You will also need to provide dependencies for the git install yourself, as Filelocker does not provide a requirements.txt:

``` puppet
# Pip might be a better/easier option here than distro packages. Here are the packages on RHEL7, for example...
$dep_packages = [
  'MySQL-python',
  'python-crypto',
  'python-cheetah',
  'python-sqlalchemy',
  'python-twisted-core',
  'python-cherrypy',
  'python-ldap',
  'SOAPpy',
]
package { $dep_packages:
  ensure => 'installed',
}
```

### Re-initialization

Once the module runs with either `$admin_manage`, `$db_init`, it leaves a breadcrumb so that these execs will not run again. Two ways to force either of these to run again are:

* Set either parameter to false for at least one agent run. Puppet will clear away the breadcrumb and it will run the corresponding exec again next time the parameter is set to `true`.
* Manually whack `${install_dir}/.admin_create.py` or `${install_dir}/.db_init.py` on the agent system. Puppet will recreate the file and run the correcsponding exec again on the next run.

### Reverse-proxy

The CherryPy server is not by itself production ready. You should front it with something else, e.g. Apache or Nginx.

Here is a chunk of a vhost config, for example, that puts Apache in front of the Filelocker server running on port `8080`:

``` ApacheConf
ProxyRequests Off
ProxyPreserveHost On
ProxyPass / http://127.0.0.1:8080/
ProxyPassReverse / http://127.0.0.1:8080/
```

## Reference

### Class: 'filelocker'

#### `exec_path`

String. Default: `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin`

#### `group`

String. Default: `root`

#### `install_dir`

String. Default: `/usr/filelocker`

#### `static_files`

A hash of static file paths and replacement files from the server, in order to overwrite default static files like the logo.
The key should be the path *under* the static directory, e.g. to replace `${install_dir}/static/images/logos/logo.gif`
you would use the key like in the example below

```
class filelocker {
	# ...
	static_files => {
		'images/logos/filelocker_logo.png' => 'puppet:///modules/profile/filelocker/usr/filelocker/static/images/logos/filelocker_logo.png',
		'images/logos/logo.gif' => 'puppet:///modules/profile/filelocker/usr/filelocker/static/images/logos/logo.gif',
	}
	# ...
}
```

Hash. Default: Undef

#### `user`

String. Default: `root`

#### `vault_dir`

String. Default: `/vault`

#### `vault_dir_manage`

Boolean. Default: `true`

#### `admin_pass`

String. Required, no default

#### `admin_manage`

Boolean. Default: `true`

#### `db_init`

Boolean. Default: `true`

#### `tools_sessions_on`

Boolean. Default: `true`

#### `tools_sessions_httponly`

Boolean. Default: `true`

#### `tools_sessions_persistent`

Boolean. Default: `false`

#### `engine_autoreload_on`

Boolean. Default: `false`

#### `tools_sessions_secure`

Boolean. Default: `false`

#### `server_thread_pool`

Integer. Default: `20`

#### `log_screen`

Boolean. Default: `false`

#### `tools_sessions_name`

String. Default: `filelocker`

#### `server_socket_port`

Integer. Default: `8080`

#### `tools_gzip_on`

Boolean. Default: `true`

#### `log_access_file`

String. Default: `filelocker.access.log`

#### `server_reverse_dns`

Boolean. Default: `false`

#### `tools_gzip_mime_types`

Array[String]. Default: `['text/html', 'text/css', 'image/jpeg', 'image/gif', 'text/javascript', 'image/png']`

#### `tools_sessions_storage_type`

String. Default: `ram`

#### `tools_sessions_timeout`

Integer. Default: `15`

#### `server_environment`

String. Default: `production`

#### `server_socket_timeout`

Integer. Default: `60`

#### `log_error_file`

String. Default: `filelocker_error_log`

#### `server_socket_host`

String. Default: `0.0.0.0`

#### `tools_satransaction_on`

Boolean. Default: `true`

#### `tools_satransaction_echo`

Boolean. Default: `false`

#### `vault`

String. Default: `/vault`

#### `fqdn`

String. Default: `$::facts['networking']['fqdn']`

#### `root_url`

String. Default: `undef`

#### `root_path`

String. Default: `/usr/filelocker`

#### `cluster_member_id`

Integer. Default: `0`

#### `tools_staticdir_root`

String. Default: `/usr/filelocker`

#### `tools_staticdir_dir`

String. Default: `static`

#### `tools_staticdir_on`

Boolean. Default: `true`

#### `dbtype`

String. Default: `mysql`

#### `dbuser`

String. Default: `filelocker`

#### `dbhost`

String. Required, no default

#### `dbname`

String. Default: `filelocker`

#### `dbpassword`

String. Required, no default

#### `admin_email`

String. Default: `admin@mycompany.com`

#### `antivirus_command`

String. Default: `clamscan`

#### `auth_type`

String. Default: `local`

#### `banner`

String. Default: ``

#### `cas_url`

String. Default: ``

#### `cli_feature`

Enum['Yes', 'No']. Default: `true`

#### `default_quota`

Integer. Default: `750`

#### `delete_arguments`

String. Default: `-f`

#### `delete_command`

String. Default: `rm`

#### `directory_type`

Enum['local', 'cas', 'ldap']. Default: `local`

#### `file_command`

String. Default: `file -b`

#### `geotagging`

Enum['Yes', 'No']. Default: `false`

#### `ldap_bind_dn`

String. Default: ``

#### `ldap_bind_pass`

String. Default: ``

#### `ldap_bind_user`

String. Default: ``

#### `ldap_displayname_attr`

String. Default: `displayName`

#### `ldap_domain_name`

String. Default: ``

#### `ldap_email_attr`

String. Default: `mail`

#### `ldap_first_name_attr`

String. Default: `givenName`

#### `ldap_host`

String. Default: ``

#### `ldap_is_active_directory`

Enum['Yes', 'No']. Default: `false`

#### `ldap_last_name_attr`

String. Default: `sn`

#### `ldap_user_name_attr`

String. Default: `uid`

#### `max_file_life_days`

Integer. Default: `7`

#### `max_file_size`

Integer. Default: `4812`

#### `org_name`

String. Default: `My Company`

#### `org_url`

String. Default: `http://www.mycompany.com`

#### `smtp_auth_required`

Enum['Yes', 'No']. Default: `false`

#### `smtp_obscure_links`

Enum['Yes', 'No']. Default: `true`

#### `smtp_pass`

String. Default: ``

#### `smtp_port`

Integer. Default: `25`

#### `smtp_sender`

String. Default: `filelocker@mycompany.com`

#### `smtp_server`

String. Default: ``

#### `smtp_start_tls`

Enum['Yes', 'No']. Default: `false`

#### `smtp_user`

String. Default: ``

#### `user_inactivity_expiration`

Integer. Default: `90`

#### `use_x_forwarded_for`

Enum['Yes', 'No']. Default: `false`

#### `package_ensure`

Variant[Boolean, String]. Default: `installed`

#### `package_name`

String. Default: `filelocker`

#### `package_provider`

Variant[String, Undef]. Default: `undef`

#### `package_source`

Variant[String, Undef]. Default: `undef`

#### `package_vcs_revision`

String. Default: `HEAD`

#### `service_ensure`

Variant[Boolean, Enum['stopped', 'running']]. Default: `running`

#### `service_manage`

Boolean. Default: `true`

#### `service_name`

String. Default: `filelocker`


## Development

I'm into pull requests if you are. Keep in mind whether your change may be out of the scope of this module though.
