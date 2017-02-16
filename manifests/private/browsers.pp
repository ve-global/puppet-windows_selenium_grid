class windows_selenium_grid::private::browsers(
  $working_directory,
  $temp_directory,
  $download_root,
  $firefox_versions,
  $internet_explorer,
  $google_chrome,
  $seven_zip_path,
  $selenium_version,
  $chromedriver_version,
) {

  $firefox_directory = "${working_directory}\\firefox"

  file { $firefox_directory:
    ensure  => directory,
    require => File[$working_directory],
  }

  ensure_resource('windows_selenium_grid::private::browsers_firefox', $firefox_versions,
    {
      ensure            => present,
      working_directory => $temp_directory,
      install_directory => $firefox_directory,
      require           => File[$firefox_directory],
    }
  )

  ensure_resource('Class', 'windows_selenium_grid::private::browsers_firefox_profiles',
    {
      ensure            => present,
      working_directory => $temp_directory,
      install_directory => $working_directory,
      seven_zip_path    => $seven_zip_path,
      require           => Windows_selenium_grid::Private::Browsers_firefox[$firefox_versions]
    }
  )

  ensure_resource('Class', 'windows_selenium_grid::private::browsers_internet_explorer',
    {
      ensure            => $internet_explorer,
      download_root     => $download_root,
      drivers_directory => $working_directory,
      seven_zip_path    => $seven_zip_path,
      selenium_version  => $selenium_version,
      require           => Class['windows_selenium_grid::private::browsers_firefox_profiles']
    }
  )

  ensure_resource('Class', 'windows_selenium_grid::private::browsers_chrome',
    {
      ensure               => $google_chrome,
      download_root        => $download_root,
      working_directory    => $working_directory,
      seven_zip_path       => $seven_zip_path,
      selenium_version     => $selenium_version,
      chromedriver_version => $chromedriver_version,
      require              => Class['windows_selenium_grid::private::browsers_internet_explorer']
    }
  )

}
