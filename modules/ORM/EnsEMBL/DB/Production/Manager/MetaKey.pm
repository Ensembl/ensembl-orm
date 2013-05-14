package ORM::EnsEMBL::DB::Production::Manager::MetaKey;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Production::Object::MetaKey;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Production::Object::MetaKey' }

1;