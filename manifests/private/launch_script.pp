class windows_selenium_grid::private::launch_script(
  $ensure,
  $version,
  $build_version,
  $working_directory,
) {

  $firefox_profile_directory = "${working_directory}\\firefox\\profile"
  $selenium_node_config_file = "${working_directory}\\selenium-${version}-config.json"
  $selenium_jar_file         = "${working_directory}\\selenium-server-standalone-${version}.${build_version}.jar"

  $scripts_directory  = "${working_directory}\\tasks"
  $launch_script_path = "${scripts_directory}\\launch-selenium-${version}.bat"

  case downcase($ensure) {
    'present': {
      file { $scripts_directory:
        ensure => directory,
        mode   => '0777',
      }

      file { $launch_script_path:
        ensure  => $ensure,
        content => template('windows_selenium_grid/launch_script.bat.erb'),
        mode    => '0777',
        notify  => Reboot['after-configuring-selenium-grid'],
        require => File[$scripts_directory],
      }

      registry_value { 'HKLM\Software\Microsoft\Windows\CurrentVersion\Run\SeleniumGridNode':
        ensure  => $ensure,
        type    => string,
        data    => "C:\\Windows\\System32\\cmd.exe /K \"${launch_script_path}\"",
        require => File[$launch_script_path],
      }
    }

    default: {
      fail('Not yet supported..')
    }
  }



}
