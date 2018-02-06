# @api private
# This class installs filelocker
class filelocker::install inherits filelocker {
  File {
    owner => $filelocker::user,
    group => $filelocker::group,
  }

  if $filelocker::package_provider == 'git' {
    file { $filelocker::install_dir:
      ensure => 'directory',
      mode   => '0700',
    }
    ->  vcsrepo { $filelocker::install_dir:
      ensure   => 'present',
      provider => $filelocker::package_provider,
      source   => $filelocker::package_source,
      revision => $filelocker::package_vcs_revision,
      user     => $filelocker::user,
      group    => $filelocker::group,
    }
    $filelocker::static_files.each |$staticpath, $sourcefile| {
      file { "${filelocker::install_dir}/${staticpath}":
        ensure  => 'file',
        backup  => '.puppet-bak',
        source  => $sourcefile,
        require =>  Vcsrepo[$filelocker::install_dir],
      }
    }
  } else {
    package { $filelocker::package_name:
      ensure   => $filelocker::package_ensure,
      provider => $filelocker::package_provider,
      source   => $filelocker::package_source,
    }
    -> $filelocker::static_files.each |$path, $sourcefile| {
      file { "${filelocker::install_dir}/${path}":
        ensure  => 'file',
        backup  => '.puppet-bak',
        source  => $sourcefile,
        require => Package[$filelocker::install_dir],
      }
    }

  }
}
