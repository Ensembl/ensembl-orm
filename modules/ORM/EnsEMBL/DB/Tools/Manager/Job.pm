package ORM::EnsEMBL::DB::Tools::Manager::Job;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::Job;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Tools::Object::Job' }

1;
