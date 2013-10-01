package ORM::EnsEMBL::DB::Tools::Manager::Result;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Result;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Result' }

1;
