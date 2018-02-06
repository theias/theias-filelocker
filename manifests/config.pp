# @api private
# This class configures Filelocker
class filelocker::config inherits filelocker {
  File {
    owner => $filelocker::user,
    group => $filelocker::group,
  }

  $service_require = $filelocker::service_manage ? {
    false => undef,
    true  => Service[$filelocker::service_name],
  }

  # File-based config options
  $filelocker_conf = {
    'tools_sessions_on'           => $filelocker::tools_sessions_on,
    'tools_sessions_httponly'     => $filelocker::tools_sessions_httponly,
    'tools_sessions_persistent'   => $filelocker::tools_sessions_persistent,
    'engine_autoreload_on'        => $filelocker::engine_autoreload_on,
    'tools_sessions_secure'       => $filelocker::tools_sessions_secure,
    'server_thread_pool'          => $filelocker::server_thread_pool,
    'log_screen'                  => $filelocker::log_screen,
    'tools_sessions_name'         => $filelocker::tools_sessions_name,
    'server_socket_port'          => $filelocker::server_socket_port,
    'tools_gzip_on'               => $filelocker::tools_gzip_on,
    'log_access_file'             => $filelocker::log_access_file,
    'server_reverse_dns'          => $filelocker::server_reverse_dns,
    'tools_gzip_mime_types'       => $filelocker::tools_gzip_mime_types,
    'tools_sessions_storage_type' => $filelocker::tools_sessions_storage_type,
    'tools_sessions_timeout'      => $filelocker::tools_sessions_timeout,
    'server_environment'          => $filelocker::server_environment,
    'server_socket_timeout'       => $filelocker::server_socket_timeout,
    'log_error_file'              => $filelocker::log_error_file,
    'server_socket_host'          => $filelocker::server_socket_host,
    'tools_satransaction_on'      => $filelocker::tools_satransaction_on,
    'tools_satransaction_echo'    => $filelocker::tools_satransaction_echo,
    'vault'                       => $filelocker::vault,
    'fqdn'                        => $filelocker::fqdn,
    'root_url'                    => $filelocker::root_url,
    'root_path'                   => $filelocker::root_path,
    'cluster_member_id'           => $filelocker::cluster_member_id,
    'tools_staticdir_root'        => $filelocker::tools_staticdir_root,
    'tools_staticdir_dir'         => $filelocker::tools_staticdir_dir,
    'tools_staticdir_on'          => $filelocker::tools_staticdir_on,
    'dbtype'                      => $filelocker::dbtype,
    'dbuser'                      => $filelocker::dbuser,
    'dbhost'                      => $filelocker::dbhost,
    'dbname'                      => $filelocker::dbname,
    'dbpassword'                  => $filelocker::dbpassword,
  }
  file { "${filelocker::install_dir}/etc/filelocker.conf":
    ensure  => 'file',
    mode    => '0600',
    content => epp('filelocker/install_dir/etc/filelocker.conf.epp', $filelocker_conf),
    notify  => $filelocker::notify,
  }
  # DB-based config options
  # Init db
  if $filelocker::db_init {
    $db_params = {
      'dburi' => $filelocker::dburi,
    }
    file { "${filelocker::install_dir}/.db_init.py":
      ensure  => 'file',
      mode    => '0600',
      content => epp('filelocker/install_dir/db_init.py.epp', $db_params),
    }
    ~> exec { 'init_filelocker_db':
      path        => $filelocker::exec_path,
      cwd         => $filelocker::install_dir,
      command     => 'python .db_init.py',
      refreshonly => true,
      require     => $service_require,
    }
  } else {
    file { "${filelocker::install_dir}/.db_init.py":
      ensure => 'absent',
    }
  }
  # If managing db init, make sure it comes before other db execs
  $requireinit = $filelocker::db_init ? {
    true  => Exec['init_filelocker_db'],
    false => undef,
  }

  # Create admin user
  if $filelocker::admin_manage {
    $admin_params = {
      'dburi' => $filelocker::dburi,
      'password' => hiera('filelocker::admin::password'),
    }
    file { "${filelocker::install_dir}/.admin_create.py":
      ensure  => 'file',
      mode    => '0600',
      content => epp('filelocker/install_dir/admin_create.py.epp', $admin_params),
    }
    ~> exec { 'create_filelocker_admin':
      path        => $filelocker::exec_path,
      cwd         => $filelocker::install_dir,
      command     => 'python .admin_create.py',
      refreshonly => true,
      require     => $service_require,
    }
  } else {
    file { "${filelocker::install_dir}/.admin_create.py":
      ensure => 'absent',
    }
  }
  # DB-based opts
  $dbopts ={
    'keyvals' => {
      'admin_email'                => $filelocker::admin_email,
      'antivirus_command'          => $filelocker::antivirus_command,
      'auth_type'                  => $filelocker::auth_type,
      'banner'                     => $filelocker::banner,
      'cas_url'                    => $filelocker::cas_url,
      'cli_feature'                => $filelocker::cli_feature,
      'default_quota'              => $filelocker::default_quota,
      'delete_arguments'           => $filelocker::delete_arguments,
      'delete_command'             => $filelocker::delete_command,
      'directory_type'             => $filelocker::directory_type,
      'file_command'               => $filelocker::file_command,
      'geotagging'                 => $filelocker::geotagging,
      'ldap_bind_dn'               => $filelocker::ldap_bind_dn,
      'ldap_bind_pass'             => $filelocker::ldap_bind_pass,
      'ldap_bind_user'             => $filelocker::ldap_bind_user,
      'ldap_displayname_attr'      => $filelocker::ldap_displayname_attr,
      'ldap_domain_name'           => $filelocker::ldap_domain_name,
      'ldap_email_attr'            => $filelocker::ldap_email_attr,
      'ldap_first_name_attr'       => $filelocker::ldap_first_name_attr,
      'ldap_host'                  => $filelocker::ldap_host,
      'ldap_is_active_directory'   => $filelocker::ldap_is_active_directory,
      'ldap_last_name_attr'        => $filelocker::ldap_last_name_attr,
      'ldap_user_name_attr'        => $filelocker::ldap_user_name_attr,
      'max_file_life_days'         => $filelocker::max_file_life_days,
      'max_file_size'              => $filelocker::max_file_size,
      'org_name'                   => $filelocker::org_name,
      'org_url'                    => $filelocker::org_url,
      'smtp_auth_required'         => $filelocker::smtp_auth_required,
      'smtp_obscure_links'         => $filelocker::smtp_obscure_links,
      'smtp_pass'                  => $filelocker::smtp_pass,
      'smtp_port'                  => $filelocker::smtp_port,
      'smtp_sender'                => $filelocker::smtp_sender,
      'smtp_server'                => $filelocker::smtp_server,
      'smtp_start_tls'             => $filelocker::smtp_start_tls,
      'smtp_user'                  => $filelocker::smtp_user,
      'user_inactivity_expiration' => $filelocker::user_inactivity_expiration,
      'use_x_forwarded_for'        => $filelocker::use_x_forwarded_for,
    }
  }
  file { "${filelocker::install_dir}/.my.cnf":
    ensure  => 'file',
    content => "[client]\nuser=${filelocker::dbuser}\npassword=\"${filelocker::dbpassword}\"\n",
    mode    => '0600',
  }
  # Hey why are we updating every time? Is this wasteful?
  # An empty update will do no harm and cost nearly nothing, while a conditional
  # update would just be more 'work' for the same effect. Especially considering the low
  # overhead of this single connection. So, whatever, just update it
  file { "${filelocker::install_dir}/.dbconfig.mysql":
    ensure  => 'file',
    content => epp('filelocker/install_dir/dbconfig.mysql.epp', $dbopts),
    mode    => '0600',
  }
  ~> exec { 'update_db_configs_filelocker':
    command => "mysql --defaults-file='${filelocker::install_dir}/.my.cnf' -h ${filelocker::dbhost} ${filelocker::dbname} < '${filelocker::install_dir}/.dbconfig.mysql'", # lint:ignore:140chars
    cwd     => $filelocker::install_dir,
    path    => $filelocker::exec_path,
    user    => $filelocker::user,
    require => $requireinit,
  }
}

