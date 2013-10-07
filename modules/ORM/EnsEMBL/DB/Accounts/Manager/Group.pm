package ORM::EnsEMBL::DB::Accounts::Manager::Group;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::Rose::Manager);

sub fetch_with_members {
  ## Fetchs group(s) with given id(s) along with it's members
  ## @param Group id OR ArrayRef of group ids if multiple groups
  ## @param Flag if on, will return the active only users
  ## @return Rose::Object drived object, or arrayref of same if arrayref of ids provided as argument
  my ($self, $ids, $active_only) = @_;
  
  return unless $ids;
  
  my $method          = ref $ids eq 'ARRAY' ? 'fetch_by_primary_keys' : 'fetch_by_primary_key';
  my $params          = {'with_objects' => ['memberships', 'memberships.user'], 'sort_by' => 'user.name'};
  $params->{'query'}  = ['memberships.member_status', 'active', 'memberships.status', 'active'] if $active_only;

  return $self->$method($ids, $params);
}

1;