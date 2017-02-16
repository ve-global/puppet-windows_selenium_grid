class windows_selenium_grid::private::download(
  $version,
  $download_url,
  $jar_file_name,
  $working_directory,
) {

  download_file { $jar_file_name:
    url                   => $download_url,
    destination_file      => $jar_file_name,
    destination_directory => $working_directory,
  }

}
