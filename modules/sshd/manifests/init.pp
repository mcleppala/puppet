# SSHd install & configure, bypass Ubuntu 12.04 init script bug
# Copyright 2013 Tero Karvinen http://terokarvinen.com

class sshd {
	package { 'openssh-server':
		ensure => 'installed',
		allowcdrom => 'true',
	}
	
	file { '/etc/ssh/sshd_config':
		content => template('sshd/sshd_config'),
		require => Package['openssh-server'],
		notify => Service['ssh'],
	}

	service { 'ssh':
		ensure => 'running',
		enable => 'true',
		require => Package['openssh-server'],
	}
}
