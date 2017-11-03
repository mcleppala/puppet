class mysql {
	package { 'mysql-server':
		ensure => 'installed',
		allowcdrom => 'true',
	}

	package { 'mysql-client':
		ensure => 'installed',
		allowcdrom => 'true',
	}
  #http://terokarvinen.com/2015/preseed-mysql-server-password-with-salt-stack
}
