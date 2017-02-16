# Puppet Windows Selenium Grid (Client)

This module configures a Windows node for use as a Selenium Grid client - supporting Firefox, Chrome and Internet Explorer out of the box.

_side-note: Selenium 2 doesn't support Firefox beyond version 47.0.1 - you'll want to use Selenium Grid 3 to avoid this._

[![Build Status](https://travis-ci.org/ve-interactive/puppet-windows_selenium_grid.png?branch=master)](https://travis-ci.org/ve-interactive/puppet-windows_selenium_grid)

You'll probably want to use it in conjunction with

## Example usage (minimal)
```
class { '::windows_selenium_grid':
  ensure               => 'present',
  selenium_grid_host   => 'selenium-grid-server.me.com',
  version              => '2.51',
  build_version        => '0',
  internet_explorer    => true,
  install_directory    => 'C:\selenium',
  firefox_versions     => [ '47.0.1' ],
  google_chrome        => true,
  chromedriver_version => '2.27',
}
```

## Example usage (with auto-login)
```

$username = 'some_user'
$password = 'M@g1CM0u5e!'
$install_directory = 'C:\selenium'
$selenium_grid_host = 'selenium-grid-server.me.com'
$version = '2.51'
$build_version = '0'
$firefox_versions = [ '47.0.1' ]
$chromedriver_version = '2.27'

user { $username:
  ensure   => present,
  password => $password,
  groups   => [ 'Users' ],
}

file { $install_directory:
  ensure  => directory,
  require => User[$username],
}

class { '::windows_autologin':
  ensure   => 'present',
  username => $username,
  password => $password,
  require  => File[$install_directory],
}

class { '::windows_selenium_grid':
  ensure               => 'present',
  selenium_grid_host   => $selenium_grid_host,
  version              => $version,
  build_version        => $build_version,
  internet_explorer    => true,
  install_directory    => $install_directory,
  firefox_versions     => $firefox_versions,
  google_chrome        => true,
  chromedriver_version => $chromedriver_version,
  require              => Class['windows_autologin'],
}
```

## Contributing

* Fork it
* Create a feature branch (`git checkout -b my-new-feature`)
* Commit your changes (`git commit -am 'Added some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create new Pull Request
