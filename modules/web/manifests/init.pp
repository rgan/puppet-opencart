class web ($oc_url = 'http://opencart.googlecode.com/files/opencart_v1.4.9.4.zip', 
  $dbhost='localhost', $dbname='opencart', $dbuser='opencart', $dbpwd='') {

package { ["apache2", "php5", "mysql-client"] : ensure => installed }
  
exec { "download-opencart" :
  command => "curl $oc_url > opencart.zip",  
	cwd => "/var/tmp",
  creates => "/var/tmp/opencart.zip",
  path => ["/usr/bin", "/usr/sbin"],
  require => Package["apache2"]
}

exec { "unzip-opencart" :
  command => "unzip -d opencart opencart.zip",
  cwd => "/var/tmp",
  creates => "/var/tmp/opencart",
  path => ["/usr/bin", "/usr/sbin"]
}

exec { "upload-opencart":
  command => "cp -r upload/* /var/www",
  cwd => "/var/tmp/opencart",
  creates => "/var/www/install",
  path => ["/bin", "/usr/bin", "/usr/sbin"]
}

exec { "setup-db-schema" :
  cwd => "/var/www/install",
  unless => "/usr/bin/mysql -h $dbhost -u$dbuser -p$dbpwd $dbname -e 'select * from oc_address'",
  command => "/usr/bin/mysql -h $dbhost -u$dbuser -p$dbpwd $dbname -e \"source opencart.sql;\"",
	require => Package["mysql-client"]
}

exec { "remove-install" : 
  command => "rm -rf install",
  cwd => "/var/www",
  path => ["/bin", "/usr/bin", "/usr/sbin"],
  onlyif => "test -f /var/www/install/opencart.sql"
}

file { "/var/www/config.php" :
  ensure => present,
  content => template("web/config.php.erb"),
}

Exec["download-opencart"] -> Exec["unzip-opencart"] -> Exec["upload-opencart"] -> Exec["setup-db-schema"] -> Exec["remove-install"]
}