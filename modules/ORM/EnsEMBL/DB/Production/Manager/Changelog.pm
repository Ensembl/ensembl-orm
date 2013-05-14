package ORM::EnsEMBL::DB::Production::Manager::Changelog;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::Changelog;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::Changelog' }

1;