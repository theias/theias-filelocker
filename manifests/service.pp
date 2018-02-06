# @api private
# This class manages the filelocker service
class filelocker::service inherits filelocker {
  if $filelocker::service_manage {
    service { $filelocker::service_name:
      ensure => $filelocker::service_ensure,
    }
  }
}

