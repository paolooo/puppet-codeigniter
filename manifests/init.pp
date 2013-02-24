class codeigniter {
  exec { 'download-codeigniter':
    cwd     => '/tmp',
    command => '/usr/bin/wget http://ellislab.com/codeigniter/download',
    creates => '/tmp/download.zip'
  }
  
  exec { 'unzip-codeigniter':
    cwd     => '/tmp',
    command => "/usr/bin/unzip download.zip && /bin/mv Codeigniter_*/* ${docroot}",
    require => [ Package['unzip'], Exec['download-codeigniter'] ]
  }

  file { "${docroot}":
    ensure  => 'directory'
  }

  #$writeable_dirs = ["${docroot}/app/storage"]
  #file { "${writeable_dirs}":
  #  ensure  => 'directory',
  #  recurse => true,
  #  mode    => '0777',
  #  require => File["${docroot}"]
  #}

  # add .htaccess
  file { 'add-htaccess':
    path    => "${docroot}/.htaccess",
    content => template('codeigniter/.htaccess'),
    ensure  => file,
    require => [ Exec['unzip-codeigniter'] ]
  }
}
