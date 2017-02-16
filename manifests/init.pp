class windows_selenium_grid(
  $ensure,
  $selenium_grid_host,
  $install_directory,
  $version                   = $windows_selenium_grid::params::version,
  $build_version             = $windows_selenium_grid::params::build_version,
  $firefox_versions          = $windows_selenium_grid::params::firefox_versions,
  $internet_explorer         = $windows_selenium_grid::params::internet_explorer,
  $internet_explorer_version = $windows_selenium_grid::params::internet_explorer_version,
  $google_chrome             = $windows_selenium_grid::params::google_chrome,
  $chromedriver_version      = $windows_selenium_grid::params::chromedriver_version,
  $download_root             = $windows_selenium_grid::params::download_root,
  $temp_directory            = $windows_selenium_grid::params::temp_directory,
  $selenium_grid_client_port = $windows_selenium_grid::params::selenium_grid_client_port,
  $seven_zip_path            = $windows_selenium_grid::params::seven_zip_path,
) inherits windows_selenium_grid::params {

  $jar_file_name = "selenium-server-standalone-${version}.${build_version}.jar"
  $download_url  = "${download_root}/${version}/${jar_file_name}"

  case downcase($::osfamily) {
    'windows': {
      class { '::windows_selenium_grid::private::download':
        version           => $version,
        download_url      => $download_url,
        jar_file_name     => $jar_file_name,
        working_directory => $install_directory,
      }

      class { '::windows_selenium_grid::private::browsers':
        working_directory    => $install_directory,
        temp_directory       => $temp_directory,
        download_root        => $download_root,
        firefox_versions     => $firefox_versions,
        internet_explorer    => $internet_explorer,
        google_chrome        => $google_chrome,
        seven_zip_path       => $seven_zip_path,
        selenium_version     => $version,
        chromedriver_version => $chromedriver_version,
        require              => Class['windows_selenium_grid::private::download'],
        notify               => Reboot['after-configuring-selenium-grid'],
      }

      class { '::windows_selenium_grid::private::config':
        version                   => $version,
        selenium_grid_host        => $selenium_grid_host,
        working_directory         => $install_directory,
        firefox_versions          => $firefox_versions,
        internet_explorer         => $internet_explorer,
        internet_explorer_version => $internet_explorer_version,
        google_chrome             => $google_chrome,
        chromedriver_version      => $chromedriver_version,
        require                   => Class['windows_selenium_grid::private::browsers'],
        notify                    => Reboot['after-configuring-selenium-grid'],
      }

      class { '::windows_selenium_grid::private::launch_script':
        ensure            => $ensure,
        version           => $version,
        build_version     => $build_version,
        working_directory => $install_directory,
        require           => Class['windows_selenium_grid::private::config'],
        notify            => Reboot['after-configuring-selenium-grid'],
      }

      # force the logon script to be re-launched via a reboot..
      reboot { 'after-configuring-selenium-grid':
        subscribe => Class['windows_selenium_grid::private::launch_script'],
      }
    }

    default: {
      fail("windows_selenium_grid does not support the OS '${::osfamily}'")
    }
  }

}
