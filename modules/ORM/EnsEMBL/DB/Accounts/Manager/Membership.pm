package ORM::EnsEMBL::DB::Accounts::Manager::Membership;

use strict;
use warnings;

use ORM::EnsEMBL::DB::Accounts::Object::Membership;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub object_class { 'ORM::EnsEMBL::DB::Accounts::Object::Membership' }

1;