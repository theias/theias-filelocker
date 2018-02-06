# filelocker
#
# Class to manage installation and configuration of Filelocker
#
# @summary "Filelocker is a web based secure file sharing application that facilitates easy file sharing between users
# at an organization and promotes secure data sharing habits." -[Filelocker site](http://filelocker2.sourceforge.net/)
#
# @example
#   class { 'filelocker':
#     admin_pass => '***',
#     dbpassword => '***',
#     dbhost     => 'db.domain.tld',
#   }
#
# @param `exec_path`
# String. Default: `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin`
#
# @param `group`
# String. Default: `root`
# 
# @param `install_dir`
# String. Default: `/usr/filelocker`
#
# @param `static_files`
# Hash. Default: Undef

# @param `user`
# String. Default: `root`
# 
# @param `vault_dir`
# String. Default: `/vault`
# 
# @param `vault_dir_manage`
# Boolean. Default: `true`
# 
# @param `admin_pass`
# String. Required, no default
# 
# @param `admin_manage`
# Boolean. Default: `true`
# 
# @param `db_init`
# Boolean. Default: `true`
# 
# @param `tools_sessions_on`
# Boolean. Default: `true`
# 
# @param `tools_sessions_httponly`
# Boolean. Default: `true`
# 
# @param `tools_sessions_persistent`
# Boolean. Default: `false`
# 
# @param `engine_autoreload_on`
# Boolean. Default: `false`
# 
# @param `tools_sessions_secure`
# Boolean. Default: `false`
# 
# @param `server_thread_pool`
# Integer. Default: `20`
# 
# @param `log_screen`
# Boolean. Default: `false`
# 
# @param `tools_sessions_name`
# String. Default: `filelocker`
# 
# @param `server_socket_port`
# Integer. Default: `8080`
# 
# @param `tools_gzip_on`
# Boolean. Default: `true`
# 
# @param `log_access_file`
# String. Default: `filelocker.access.log`
# 
# @param `server_reverse_dns`
# Boolean. Default: `false`
# 
# @param `tools_gzip_mime_types`
# Array[String]. Default: `['text/html', 'text/css', 'image/jpeg', 'image/gif', 'text/javascript', 'image/png']`
# 
# @param `tools_sessions_storage_type`
# String. Default: `ram`
# 
# @param `tools_sessions_timeout`
# Integer. Default: `15`
# 
# @param `server_environment`
# String. Default: `production`
# 
# @param `server_socket_timeout`
# Integer. Default: `60`
# 
# @param `log_error_file`
# String. Default: `filelocker_error_log`
# 
# @param `server_socket_host`
# String. Default: `0.0.0.0`
# 
# @param `tools_satransaction_on`
# Boolean. Default: `true`
# 
# @param `tools_satransaction_echo`
# Boolean. Default: `false`
# 
# @param `vault`
# String. Default: `/vault`
# 
# @param `fqdn`
# String. Default: `$::facts['networking']['fqdn']`
# 
# @param `root_url`
# String. Default: `undef`
# 
# @param `root_path`
# String. Default: `/usr/filelocker`
# 
# @param `cluster_member_id`
# Integer. Default: `0`
# 
# @param `tools_staticdir_root`
# String. Default: `/usr/filelocker`
# 
# @param `tools_staticdir_dir`
# String. Default: `static`
# 
# @param `tools_staticdir_on`
# Boolean. Default: `true`
# 
# @param `dbtype`
# String. Default: `mysql`
# 
# @param `dbuser`
# String. Default: `filelocker`
# 
# @param `dbhost`
# String. Required, no default
# 
# @param `dbname`
# String. Default: `filelocker`
# 
# @param `dbpassword`
# String. Required, no default
# 
# @param `admin_email`
# String. Default: `admin@mycompany.com`
# 
# @param `antivirus_command`
# String. Default: `clamscan`
# 
# @param `auth_type`
# String. Default: `local`
# 
# @param `banner`
# String. Default: ``
# 
# @param `cas_url`
# String. Default: ``
# 
# @param `cli_feature`
# Enum['Yes', 'No']. Default: `true`
# 
# @param `default_quota`
# Integer. Default: `750`
# 
# @param `delete_arguments`
# String. Default: `-f`
# 
# @param `delete_command`
# String. Default: `rm`
# 
# @param `directory_type`
# Enum['local', 'cas', 'ldap']. Default: `local`
# 
# @param `file_command`
# String. Default: `file -b`
# 
# @param `geotagging`
# Enum['Yes', 'No']. Default: `false`
# 
# @param `ldap_bind_dn`
# String. Default: ``
# 
# @param `ldap_bind_pass`
# String. Default: ``
# 
# @param `ldap_bind_user`
# String. Default: ``
# 
# @param `ldap_displayname_attr`
# String. Default: `displayName`
# 
# @param `ldap_domain_name`
# String. Default: ``
# 
# @param `ldap_email_attr`
# String. Default: `mail`
# 
# @param `ldap_first_name_attr`
# String. Default: `givenName`
# 
# @param `ldap_host`
# String. Default: ``
# 
# @param `ldap_is_active_directory`
# Enum['Yes', 'No']. Default: `false`
# 
# @param `ldap_last_name_attr`
# String. Default: `sn`
# 
# @param `ldap_user_name_attr`
# String. Default: `uid`
# 
# @param `max_file_life_days`
# Integer. Default: `7`
# 
# @param `max_file_size`
# Integer. Default: `4812`
# 
# @param `org_name`
# String. Default: `My Company`
# 
# @param `org_url`
# String. Default: `http://www.mycompany.com`
# 
# @param `smtp_auth_required`
# Enum['Yes', 'No']. Default: `false`
# 
# @param `smtp_obscure_links`
# Enum['Yes', 'No']. Default: `true`
# 
# @param `smtp_pass`
# String. Default: ``
# 
# @param `smtp_port`
# Integer. Default: `25`
# 
# @param `smtp_sender`
# String. Default: `filelocker@mycompany.com`
# 
# @param `smtp_server`
# String. Default: ``
# 
# @param `smtp_start_tls`
# Enum['Yes', 'No']. Default: `false`
# 
# @param `smtp_user`
# String. Default: ``
# 
# @param `user_inactivity_expiration`
# Integer. Default: `90`
# 
# @param `use_x_forwarded_for`
# Enum['Yes', 'No']. Default: `false`
# 
# @param `package_ensure`
# Variant[Boolean, String]. Default: `installed`
# 
# @param `package_name`
# String. Default: `filelocker`
# 
# @param `package_provider`
# Variant[String, Undef]. Default: `undef`
# 
# @param `package_source`
# Variant[String, Undef]. Default: `undef`
# 
# @param `package_vcs_revision`
# String. Default: `HEAD`
# 
# @param `service_ensure`
# Variant[Boolean, Enum['stopped', 'running']]. Default: `running`
# 
# @param `service_manage`
# Boolean. Default: `true`
# 
# @param `service_name`
# String. Default: `filelocker`

class filelocker (
  # lint:ignore:parameter_order
  String $exec_path                                            = $filelocker::params::exec_path,
  String $group                                                = $filelocker::params::group,
  String $install_dir                                          = $filelocker::params::install_dir,
  Hash $static_files                                           = $filelocker::params::static_files,
  String $user                                                 = $filelocker::params::user,
  Boolean $vault_dir_manage                                    = $filelocker::params::vault_dir_manage,
  # DB
  String $admin_pass,
  Boolean $admin_manage                                        = $filelocker::params::admin_manage,
  Boolean $db_init                                             = $filelocker::params::db_init,
  # Conf file
  Boolean $tools_sessions_on                                   = $filelocker::params::tools_sessions_on,
  Boolean $tools_sessions_httponly                             = $filelocker::params::tools_sessions_httponly,
  Boolean $tools_sessions_persistent                           = $filelocker::params::tools_sessions_persistent,
  Boolean $engine_autoreload_on                                = $filelocker::params::engine_autoreload_on,
  Boolean $tools_sessions_secure                               = $filelocker::params::tools_sessions_secure,
  Integer $server_thread_pool                                  = $filelocker::params::server_thread_pool,
  Boolean $log_screen                                          = $filelocker::params::log_screen,
  String $tools_sessions_name                                  = $filelocker::params::tools_sessions_name,
  Integer $server_socket_port                                  = $filelocker::params::server_socket_port,
  Boolean $tools_gzip_on                                       = $filelocker::params::tools_gzip_on,
  String $log_access_file                                      = $filelocker::params::log_access_file,
  Boolean $server_reverse_dns                                  = $filelocker::params::server_reverse_dns,
  Array[String] $tools_gzip_mime_types                         = $filelocker::params::tools_gzip_mime_types,
  String $tools_sessions_storage_type                          = $filelocker::params::tools_sessions_storage_type,
  Integer $tools_sessions_timeout                              = $filelocker::params::tools_sessions_timeout,
  String $server_environment                                   = $filelocker::params::server_environment,
  Integer $server_socket_timeout                               = $filelocker::params::server_socket_timeout,
  String $log_error_file                                       = $filelocker::params::log_error_file,
  String $server_socket_host                                   = $filelocker::params::server_socket_host,
  Boolean $tools_satransaction_on                              = $filelocker::params::tools_satransaction_on,
  Boolean $tools_satransaction_echo                            = $filelocker::params::tools_satransaction_echo,
  String $vault                                                = $filelocker::params::vault,
  String $fqdn                                                 = $filelocker::params::fqdn,
  String $root_url                                             = undef,
  String $root_path                                            = $filelocker::params::root_path,
  Integer $cluster_member_id                                   = $filelocker::params::cluster_member_id,
  String $tools_staticdir_root                                 = $filelocker::params::tools_staticdir_root,
  String $tools_staticdir_dir                                  = $filelocker::params::tools_staticdir_dir,
  Boolean $tools_staticdir_on                                  = $filelocker::params::tools_staticdir_on,
  String $dbtype                                               = $filelocker::params::dbtype,
  String $dbuser                                               = $filelocker::params::dbuser,
  String $dbhost,
  String $dbname                                               = $filelocker::params::dbname,
  String $dbpassword,
  # DB Conf
  String $admin_email                                          = $filelocker::params::admin_email,
  String $antivirus_command                                    = $filelocker::params::antivirus_command,
  String $auth_type                                            = $filelocker::params::auth_type,
  String $banner                                               = $filelocker::params::banner,
  String $cas_url                                              = $filelocker::params::cas_url,
  Enum['Yes', 'No'] $cli_feature                               = $filelocker::params::cli_feature,
  Integer $default_quota                                       = $filelocker::params::default_quota,
  String $delete_arguments                                     = $filelocker::params::delete_arguments,
  String $delete_command                                       = $filelocker::params::delete_command,
  Enum['local', 'cas', 'ldap'] $directory_type                 = $filelocker::params::directory_type,
  String $file_command                                         = $filelocker::params::file_command,
  Enum['Yes', 'No']  $geotagging                               = $filelocker::params::geotagging,
  String $ldap_bind_dn                                         = $filelocker::params::ldap_bind_dn,
  String $ldap_bind_pass                                       = $filelocker::params::ldap_bind_pass,
  String $ldap_bind_user                                       = $filelocker::params::ldap_bind_user,
  String $ldap_displayname_attr                                = $filelocker::params::ldap_displayname_attr,
  String $ldap_domain_name                                     = $filelocker::params::ldap_domain_name,
  String $ldap_email_attr                                      = $filelocker::params::ldap_email_attr,
  String $ldap_first_name_attr                                 = $filelocker::params::ldap_first_name_attr,
  String $ldap_host                                            = $filelocker::params::ldap_host,
  Enum['Yes', 'No'] $ldap_is_active_directory                  = $filelocker::params::ldap_is_active_directory,
  String $ldap_last_name_attr                                  = $filelocker::params::ldap_last_name_attr,
  String $ldap_user_name_attr                                  = $filelocker::params::ldap_user_name_attr,
  Integer $max_file_life_days                                  = $filelocker::params::max_file_life_days,
  Integer $max_file_size                                       = $filelocker::params::max_file_size,
  String $org_name                                             = $filelocker::params::org_name,
  String $org_url                                              = $filelocker::params::org_url,
  Enum['Yes', 'No'] $smtp_auth_required                        = $filelocker::params::smtp_auth_required,
  Enum['Yes', 'No'] $smtp_obscure_links                        = $filelocker::params::smtp_obscure_links,
  String $smtp_pass                                            = $filelocker::params::smtp_pass,
  Integer $smtp_port                                           = $filelocker::params::smtp_port,
  String $smtp_sender                                          = $filelocker::params::smtp_sender,
  String $smtp_server                                          = $filelocker::params::smtp_server,
  Enum['Yes', 'No'] $smtp_start_tls                            = $filelocker::params::smtp_start_tls,
  String $smtp_user                                            = $filelocker::params::smtp_user,
  Integer $user_inactivity_expiration                          = $filelocker::params::user_inactivity_expiration,
  Enum['Yes', 'No'] $use_x_forwarded_for                       = $filelocker::params::use_x_forwarded_for,
  # Package
  Variant[Boolean, String] $package_ensure                     = $filelocker::params::package_ensure,
  String $package_name                                         = $filelocker::params::package_name,
  Variant[String, Undef] $package_provider                     = $filelocker::params::package_provider,
  Variant[String, Undef] $package_source                       = $filelocker::params::package_source,
  String $package_vcs_revision                                 = $filelocker::params::package_vcs_revision,
  # Service
  Variant[Boolean, Enum['stopped', 'running']] $service_ensure = $filelocker::params::service_ensure,
  Boolean $service_manage                                      = $filelocker::params::service_manage,
  String $service_name                                         = $filelocker::params::service_name,
  # lint:endignore
) inherits filelocker::params {
  include stdlib

  File {
    owner => $user,
    group => $group,
  }

  $dburi = "mysql+mysqldb://${dbuser}:${dbpassword}@${dbhost}/${dbname}"

  $notify = $service_manage ? {
    true => Service[$service_name],
    false => undef,
  }

  if $vault_dir_manage {
    file { $vault:
      ensure => 'directory',
      mode   => '0700',
    }
  }

  include filelocker::install
  include filelocker::config
  include filelocker::service
}
