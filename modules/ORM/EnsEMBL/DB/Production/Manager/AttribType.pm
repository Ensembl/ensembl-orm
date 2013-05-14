package ORM::EnsEMBL::DB::Production::Manager::AttribType;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::AttribType;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::AttribType' }

1;