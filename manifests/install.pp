define prestashop::install (
    version       => '1.6.0.9',
    verbose       => false,
    theme_dir     => '/vagrant/project',
    domain        => 'prestashop.local',
    port          => '80'
    aliases       => '',
    webserver     => 'apache',
    priority      => '20',
    docroot       => $title,
    docroot_owner => 'root',
    docroot_group => undef,
    ssl           => false,
    ssl_cert      => undef,
    ssl_key       => undef,
    db_host       => 'localhost',
    db_name       => 'ps_database',
    db_user       => 'ps_user',
    db_password   => 'ps_password',
    root_password => 'root',
) {

    validate_re($webserver, '^(apache|nginx)$', "${webserver} is not supported as webserver. Allowed values are 'apache' and 'nginx'.")
    validate_bool($ssl)

    if ! defined(Package['wget']) {
        package { 'wget' :
            ensure => present,
            before => Wget::Fetch['fetch_source_code'],
        }
    }

    if ! defined(Package['unzip']) {
        package { 'unzip' :
            ensure => present,
            before => Archive['extract_archive'],
        }
    }

    if $webserver == 'apache' {
        if ! defined(Class['apache']) {
            include apache
        }
        apache::vhost { $domain:
            aliases => $aliases,
            docroot => $docroot,
            docroot_owner => $docroot_owner,
            docroot_group => $docroot_group,
            port => $port,
            priority => $priority,
            ssl_cert => $ssl_cert,
            ssl_key => $ssl_key,
        }
    } else if $webserver == 'nginx' {
        if ! defined(Class['nginx']) {
            include nginx
        }
        nginx::vhost { $domain:
            aliases => $aliases,
            docroot => $docroot,
            docroot_owner => $docroot_owner,
            docroot_group => $docroot_group,
            port => $port,
            priority => $priority,
            ssl_cert => $ssl_cert,
            ssl_key => $ssl_key,
        }
    }

    if $db_host == 'localhost' {
        class { 'mysql::server':
            root_password    => $root_password,
            restart          => true,
            override_options => {
                'mysqld' => {
                    'max_connections' => '128',
                    'innodb_file_per_table' => 'on',
                    'innodb_buffer_pool_size' => '512M',
                    'innodb_log_buffer_size' => '4M',
                    'bind-address' => '0.0.0.0',
                }
            },
        }
        ->
        mysql::db { $db_name:
            user     => $db_user,
            password => $db_password,
        }
    }

    wget::fetch { 'fetch_source_code':
        source => "http://www.prestashop.com/download/prestashop_${version}.zip",
        destination => '/tmp/prestashop.zip',
        verbose => $verbose,
    }
    ->
    archive { "extract_archive"
        source => "/tmp/prestashop.zip",
        creates => $docroot,
    }

}