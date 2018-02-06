# Class: filelocker::params
#
# @summary This class sets defaults for the filelocker module
#
class filelocker::params {
  $exec_path                   = '/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin'
  $group                       = 'root'
  $install_dir                 = '/usr/filelocker'
  $static_files                = {}
  $user                        = 'root'
  $vault_dir_manage            = true
  # DB
  # $admin_pass
  $admin_manage                = true
  $db_init                     = true
  # Conf file
  $tools_sessions_on           = true
  $tools_sessions_httponly     = true
  $tools_sessions_persistent   = false
  $engine_autoreload_on        = false
  $tools_sessions_secure       = false
  $server_thread_pool          = 20
  $log_screen                  = false
  $tools_sessions_name         = 'filelocker'
  $server_socket_port          = 8080
  $tools_gzip_on               = true
  $log_access_file             = 'filelocker.access.log'
  $server_reverse_dns          = false
  $tools_gzip_mime_types       = ['text/html', 'text/css', 'image/jpeg', 'image/gif', 'text/javascript', 'image/png']
  $tools_sessions_storage_type = 'ram'
  $tools_sessions_timeout      = 1800
  $server_environment          = 'production'
  $server_socket_timeout       = 1800
  $log_error_file              = 'filelocker_error_log'
  $server_socket_host          = '0.0.0.0'
  $tools_satransaction_on      = true
  $tools_satransaction_echo    = false
  $vault                       = '/vault'
  $fqdn                        = $::facts['networking']['fqdn']
  $root_url                    = undef
  $root_path                   = '/usr/filelocker'
  $cluster_member_id           = 0
  $tools_staticdir_root        = '/usr/filelocker'
  $tools_staticdir_dir         = 'static'
  $tools_staticdir_on          = true
  $dbtype                      = 'mysql'
  $dbuser                      = 'filelocker'
  # $dbhost
  $dbname                      = 'filelocker'
  # $dbpassword
  # DB Conf
  $admin_email                 = 'admin@mycompany.com'
  $antivirus_command           = 'clamscan'
  $auth_type                   = 'local'
  $banner                      = ''
  $cas_url                     = ''
  $cli_feature                 = 'Yes'
  $default_quota               = 750
  $delete_arguments            = '-f'
  $delete_command              = 'rm'
  $directory_type              = 'local'
  $file_command                = 'file -b'
  $geotagging                  = false
  $ldap_bind_dn                = ''
  $ldap_bind_pass              = ''
  $ldap_bind_user              = ''
  $ldap_displayname_attr       = 'displayName'
  $ldap_domain_name            = ''
  $ldap_email_attr             = 'mail'
  $ldap_first_name_attr        = 'givenName'
  $ldap_host                   = ''
  $ldap_is_active_directory    = false
  $ldap_last_name_attr         = 'sn'
  $ldap_user_name_attr         = 'uid'
  $max_file_life_days          = 7
  $max_file_size               = 4812
  $org_name                    = 'My Company'
  $org_url                     = 'http://www.mycompany.com'
  $smtp_auth_required          = false
  $smtp_obscure_links          = true
  $smtp_pass                   = ''
  $smtp_port                   = 25
  $smtp_sender                 = 'filelocker@mycompany.com'
  $smtp_server                 = ''
  $smtp_start_tls              = false
  $smtp_user                   = ''
  $user_inactivity_expiration  = 90
  $use_x_forwarded_for         = false
  # Package
  $package_ensure              = 'installed'
  $package_name                = 'filelocker'
  $package_provider            = undef
  $package_source              = undef
  $package_vcs_revision        = 'HEAD'
  # Service
  $service_ensure              = 'running'
  $service_manage              = true
  $service_name                = 'filelocker'
}
