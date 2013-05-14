package ORM::EnsEMBL::DB::Production::Manager::Biotype;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::Biotype;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::Biotype' }

1;