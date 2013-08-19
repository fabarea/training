name             'training'
maintainer       'Fabien Udriot'
maintainer_email 'fabien.udriot@typo3.org'
license          'Apache 2.0'
description      'My Base'
version          '1.0.0'


%w{
  apache2
  mysql
  database
}.each do |cookbook|
  depends cookbook
end
