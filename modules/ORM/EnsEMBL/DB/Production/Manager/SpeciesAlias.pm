package ORM::EnsEMBL::DB::Production::Manager::SpeciesAlias;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::SpeciesAlias;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::SpeciesAlias' }

1;