puppet-prestashop
=================

This is a Puppet module which installs a Prestashop

Usage
-----

    prestashop::install{ '/var/www/internal.domain.net':
        version       => '1.6.0.9',
        theme_dir     => '/vagrant/project',
        domain        => 'internal.domain.net',
        webserver     => 'apache',
        priority      => '20',
        ssl           => true,
        ssl_cert      => 'puppet:///modules/prestashop/sslkey/internal.domain.net.crt',
        ssl_key       => 'puppet:///modules/prestashop/sslkey/internal.domain.net.private.key',
        db_host       => 'localhost',
        db_name       => 'ps_database',
        db_user       => 'ps_user',
        db_password   => 'ps_password',
    }

License
-------

You are free to fork, modify, burn, break, twist or twine this module.
If you do re-use the code, please give me credit for it though.

Contact
-------

Thomas Stägemann <thomas@staegemann.info>

Support
-------

Please log tickets and issues at my [Projects site](http://github.com/staegi/puppet-prestashop)
