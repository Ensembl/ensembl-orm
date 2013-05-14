package ORM::EnsEMBL::DB::Accounts::Manager::Login;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

use ORM::EnsEMBL::DB::Accounts::Object::Login;

sub object_class { 'ORM::EnsEMBL::DB::Accounts::Object::Login' }

sub get_with_user {
  ## Gets a Login object for given identity column value, can be an openid url or email for local accounts OR primary key
  ## @param Identity value, or primary key value
  ## @return Single login object or undef is nothing found
  my ($self, $key) = @_;

  return shift @{$self->get_objects(
    'query'         => [ ($key =~ /^[0-9]+$/ ? 'login_id' : 'identity'), $key ],
    'with_objects'  => ['user'],
    'limit'         => 1
  )};
}

1;