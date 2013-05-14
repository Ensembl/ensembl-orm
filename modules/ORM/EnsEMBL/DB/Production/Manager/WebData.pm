package ORM::EnsEMBL::DB::Production::Manager::WebData;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::WebData;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::WebData' }

1;