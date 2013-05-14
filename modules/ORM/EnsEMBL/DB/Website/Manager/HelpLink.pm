package ORM::EnsEMBL::DB::Website::Manager::HelpLink;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Website::Object::HelpLink;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Website::Object::HelpLink' }

1;