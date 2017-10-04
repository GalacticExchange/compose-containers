name             'ex2'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'supervisord'
depends 'python'
depends "java"
depends "apache2"

depends "chef-sugar"
depends "openssl", '4.4.0'

depends 'postgresql'

depends 'mysql', '~> 7.1'



#depends "mysql"
#depends "php"
#depends "database"
#depends "mysql2_chef_gem"
