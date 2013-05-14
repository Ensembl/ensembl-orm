package ORM::EnsEMBL::DB::Production::Manager::ExternalDb;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::ExternalDb;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::ExternalDb' }

1;