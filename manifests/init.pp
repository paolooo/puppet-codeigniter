class codeigniter (
  $root = $docroot
) {

  file { "${root}":
    ensure  => 'directory'
  }

  exec { 'download-codeigniter':
    cwd     => '/tmp',
    command => '/usr/bin/wget http://ellislab.com/codeigniter/download',
    creates => '/tmp/download'
  }

  
  exec { 'unzip-codeigniter':
    cwd     => '/tmp',
    command => "/usr/bin/unzip download && /bin/cp -R CodeIgniter_*/* ${root} && /bin/rm -rf download Codeigniter_*",
    require => [ File["${root}"], Package['unzip'], Exec['download-codeigniter'] ]
  }

  # http://getsparks.org/install
  exec { 'install-sparks':
    cwd     => "${root}",
    command => '/usr/bin/php -r "$(curl -fsSL http://getsparks.org/go-sparks)"',
    require => [ Package['php5-cli'], File["${root}"], ],
  }

}
