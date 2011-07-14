class db($dbname, $dbuser, $dbpwd) {
  
   package { "mysql-server" : ensure => installed }
   
   file {"/etc/mysql/conf.d/allow_external.cnf" :
         owner => mysql,
	       group => mysql,
	       mode => 0644,
	       content => "[mysqld]\n bind-address = 0.0.0.0",
	       require => Package["mysql-server"]
       }

   service { "mysql" : 
	    ensure => running,
	    enable => true,
	    hasstatus => true,
	    subscribe => File["/etc/mysql/conf.d/allow_external.cnf"]
    }

    exec { "create-db" : 
      unless => "/usr/bin/mysql -uroot $dbname",
      command => "/usr/bin/mysql -uroot -e 'create database $dbname;'",
      require => Service["mysql"]
    }

    exec { "grant-db" :
        unless => "/usr/bin/mysql -u$dbuser -p$dbpwd $dbname",
        command => "/usr/bin/mysql -uroot -e \"grant all on $dbname.* to $dbname@'%' identified by '$dbpwd';\"",
	      require => Exec["create-db"]
      }
}