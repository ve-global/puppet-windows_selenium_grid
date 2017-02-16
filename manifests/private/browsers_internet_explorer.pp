class windows_selenium_grid::private::browsers_internet_explorer(
  $ensure,
  $download_root,
  $drivers_directory,
  $seven_zip_path,
  $selenium_version
) {

  $iedriver_file = 'IEDriverServer.exe'
  $iedriver_path = "${drivers_directory}/${iedriver_file}"
  $iedriver_url  = "${download_root}/${selenium_version}/IEDriverServer_Win32_${selenium_version}.0.zip"

  case $ensure {
    true: {
      download_file { "iedriver-${selenium_version}":
        url                   => $iedriver_url,
        destination_file      => "${iedriver_file}.zip",
        destination_directory => $drivers_directory,
      }

      exec { "iedriver-${selenium_version}-extract":
        command => "${seven_zip_path}\\7z.exe e ${iedriver_path}.zip -o${drivers_directory}",
        path    => $::path,
        creates => $iedriver_path,
        require => Download_file["iedriver-${selenium_version}"],
      }
    }

    default: {
      file { "${iedriver_path}\\${iedriver_file}":
        ensure => absent,
      }
    }
  }

}
