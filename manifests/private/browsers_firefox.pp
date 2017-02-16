define windows_selenium_grid::private::browsers_firefox(
  $ensure,
  $working_directory,
  $install_directory
) {

  $version                   = $title
  $version_install_directory = "${install_directory}\\${version}"
  $exe_file_name             = "firefox-${version}.exe"
  $config_file               = "${working_directory}\\firefox-${version}-config.ini"
  $install_file              = "${working_directory}\\${exe_file_name}"

  case downcase($ensure) {
    'present': {
      # Download
      $download_url = "https://ftp.mozilla.org/pub/firefox/releases/${version}/win32/en-GB/Firefox%20Setup%20${version}.exe"
      download_file { "firefox-${version}":
        url                   => $download_url,
        destination_file      => $exe_file_name,
        destination_directory => $working_directory,
      }

      # Install
      file { $version_install_directory:
        ensure  => directory,
        require => Download_file["firefox-${version}"],
      }

      file { $config_file:
        content => template('windows_selenium_grid/firefox_setup_config.ini.erb'),
        require => File[$version_install_directory],
      }

      exec { "install-firefox-${version}":
        command => "${install_file} -ms /INI=${config_file}",
        creates => "${version_install_directory}/firefox.exe",
        require => File[$config_file],
      }
    }

    default:  {
      # NOTE: technically we should be running the uninstaller..

      file { $version_install_directory:
        ensure => absent,
      }

      file { $config_file:
        ensure => absent,
      }

      file { "${working_directory}/${exe_file_name}":
        ensure => absent,
      }
    }
  }

}
