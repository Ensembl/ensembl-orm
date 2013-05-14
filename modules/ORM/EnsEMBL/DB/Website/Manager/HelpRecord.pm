package ORM::EnsEMBL::DB::Website::Manager::HelpRecord;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Website::Object::HelpRecord;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Website::Object::HelpRecord' }

1;