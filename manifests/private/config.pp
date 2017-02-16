class windows_selenium_grid::private::config(
  $version,
  $working_directory,
  $firefox_versions,
  $internet_explorer,
  $internet_explorer_version,
  $google_chrome,
  $chromedriver_version,
  $selenium_grid_host,
) {
  $selenium_grid_client_host = $::ipaddress
  $selenium_grid_directory   = $working_directory
  $ie_driver_path            = regsubst("${working_directory}\\IEDriverServer.exe", '\\', '\\\\', 'G')
  $chrome_driver_path        = regsubst("${working_directory}\\ChromeDriver-${chromedriver_version}.exe", '\\', '\\\\', 'G')

  file { "${working_directory}/selenium-${version}-config.json":
    content => template('windows_selenium_grid/config.json.erb'),
  }
}
