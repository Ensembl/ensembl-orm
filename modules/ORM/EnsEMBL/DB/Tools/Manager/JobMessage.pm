package ORM::EnsEMBL::DB::Tools::Manager::JobMessage;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::JobMessage;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::JobMessage' }

1;
