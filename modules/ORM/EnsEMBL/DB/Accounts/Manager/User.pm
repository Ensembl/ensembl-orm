package ORM::EnsEMBL::DB::Accounts::Manager::User;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub get_by_id {
  ## Gets user by id
  ## @param String id
  ## @return User object
  my ($class, $id) = @_;

  return $id ? $class->fetch_by_primary_key($id) : undef;
}

sub get_by_email {
  ## Gets user by email
  ## @param String email
  ## @return User object
  my ($class, $email) = @_;

  return shift @{$email ? $class->get_objects('query' => [ 'email', $email ]) : []};
}

1;