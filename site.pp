$oc_dbhost = 'localhost'
$oc_webhost = 'localhost'
$oc_dbname = 'opencart'
$oc_dbuser = 'opencart'
$oc_dbpwd = 'opncrtpwd'
$db_rootpwd = 'password' 

node default {
  
  class { 'db' : 
    dbname => $oc_dbname, 
    dbuser => $oc_dbuser,
    dbpwd => $oc_dbpwd,
    dbrootpwd => $db_rootpwd
  }
  
  class { 'web' :  
            oc_url => 'http://opencart.googlecode.com/files/opencart_v1.4.9.4.zip',
            dbhost => $oc_dbhost,
            dbname => $oc_dbname, 
            dbuser => $oc_dbuser,
            dbpwd => $oc_dbpwd
  }
}
