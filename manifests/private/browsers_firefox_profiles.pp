class windows_selenium_grid::private::browsers_firefox_profiles(
  $ensure,
  $working_directory,
  $install_directory,
  $seven_zip_path,
) {

  $zip_file_path = "${working_directory}\\profile.zip"
  $profile_path  = "${install_directory}\\firefox\\profile\\"

  case downcase($ensure) {

    'present': {
      file { $zip_file_path:
        ensure  => file,
        content => file('windows_selenium_grid/firefox-profile.zip'),
      }

      exec { 'extract-profile':
        command => "${seven_zip_path}\\7z.exe x ${zip_file_path} -o${profile_path}",
        path    => $::path,
        creates => $profile_path,
        require => File[$zip_file_path],
      }
    }

    default: {
      file { $zip_file_path:
        ensure => absent,
      }

      file { $profile_path:
        ensure => absent,
      }
    }
  }

}
