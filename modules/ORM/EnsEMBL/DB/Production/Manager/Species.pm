package ORM::EnsEMBL::DB::Production::Manager::Species;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::Species;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::Species' }

1;