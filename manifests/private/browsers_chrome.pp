class windows_selenium_grid::private::browsers_chrome(
  $ensure,
  $download_root,
  $working_directory,
  $seven_zip_path,
  $selenium_version,
  $chromedriver_version,
) {

  $chrome_download_url       = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi'
  $chrome_exe_file_name      = 'chrome-enterprise-setup.msi'
  $chrome_exe_file_path      = "${working_directory}\\${chrome_exe_file_name}"

  $chromedriver_download_url  = "http://chromedriver.storage.googleapis.com/${chromedriver_version}/chromedriver_win32.zip"
  $chromedriver_file_name     = 'ChromeDriver.exe'
  $chromedriver_file_path     = "${working_directory}\\${chromedriver_file_name}"
  $chromedriver_zip_file_name = "ChromeDriver-${chromedriver_version}.zip"
  $chromedriver_zip_file_path = "${working_directory}\\${chromedriver_zip_file_name}"

  case $ensure {
    true: {
      # Download Chrome
      download_file { 'download-google-chrome':
        url                   => $chrome_download_url,
        destination_file      => $chrome_exe_file_name,
        destination_directory => $working_directory,
      }

      exec { 'install-google-chrome':
        command => "msiexec.exe /i ${chrome_exe_file_path} /quiet",
        path    => $::path,
        creates => 'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
        require => Download_file['download-google-chrome'],
      }

      # Download ChromeDriver
      download_file { "download-chromedriver-${chromedriver_version}":
        url                   => $chromedriver_download_url,
        destination_file      => $chromedriver_zip_file_name,
        destination_directory => $working_directory,
        require               => Exec['install-google-chrome'],
      }

      exec { "extract-chromedriver-${chromedriver_version}":
        command     => "${seven_zip_path}\\7z.exe x \"${chromedriver_zip_file_path}\" -o\"${working_directory}\" -aoa",
        path        => $::path,
        subscribe   => Download_file["download-chromedriver-${chromedriver_version}"],
        refreshonly => true,
      }

      exec { "rename-chromedriver-${chromedriver_version}":
        command     => "powershell -Command mv \"${working_directory}\\chromedriver.exe\" \"${working_directory}\\ChromeDriver-${chromedriver_version}.exe\"",
        path        => $::path,
        subscribe   => Exec["extract-chromedriver-${chromedriver_version}"],
        refreshonly => true,
        notify      => Reboot['after-configuring-selenium-grid'],
      }
    }

    default: {
      # NOTE: technically we should be running the uninstaller..

      file { $chrome_exe_file_path:
        ensure => absent,
      }

      file { $chromedriver_zip_file_path:
        ensure => absent,
      }

      file { $chromedriver_file_path:
        ensure => absent,
      }
    }
  }
}
