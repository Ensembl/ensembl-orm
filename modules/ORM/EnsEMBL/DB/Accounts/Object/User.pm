=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package ORM::EnsEMBL::DB::Accounts::Object::User;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Accounts::Object::RecordOwner);

use ORM::EnsEMBL::Utils::Helper qw(random_string);

use constant {
  RECORD_TYPE   => 'user',
  DEFAULT_SALT  => 'ensembl' # any random string
};

__PACKAGE__->meta->setup(
  table                 => 'user',

  columns               => [
    user_id               => { 'type' => 'serial', 'primary_key' => 1, 'not_null' => 1 },
    name                  => { 'type' => 'varchar', 'length' => '255' },
    email                 => { 'type' => 'varchar', 'length' => '255' },
    data                  => { 'type' => 'datamap' },
    organisation          => { 'type' => 'varchar', 'length' => '255' },
    country               => { 'type' => 'varchar', 'length' => '2'   },
    status                => { 'type' => 'enum', 'values' => [qw(active suspended)], 'default' => 'active' },
    salt                  => { 'type' => 'varchar', 'length' => '8', 'default' => __PACKAGE__->DEFAULT_SALT }
  ],

  trackable             => 1,

  virtual_columns       => [
    new_email             => { 'column' => 'data' }
  ],

  title_column          => 'name',

  relationships         => [
    logins                => { 'type' => 'one to many', 'class' => 'ORM::EnsEMBL::DB::Accounts::Object::Login',           'column_map' => {'user_id' => 'user_id'}  },
    memberships           => { 'type' => 'one to many', 'class' => 'ORM::EnsEMBL::DB::Accounts::Object::Membership',      'column_map' => {'user_id' => 'user_id'}, 'methods' => { map {$_, undef} qw(add_on_save count find get_set_on_save)} },
#    admin_privilege       => { 'type' => 'one to one',  'class' => 'ORM::EnsEMBL::DB::Accounts::Object::AdminPrivilage',  'column_map' => {'user_id' => 'user_id'}  },
    records               => __PACKAGE__->record_relationship_params('user_id')
  ],

  virtual_relationships => __PACKAGE__->record_relationship_types
);

sub reset_salt {
  ## Resets the random key salt
  shift->salt(random_string(8));
}

sub reset_salt_and_save {
  ## Resets the salt before saving the object - use this instead of regular save method unless reseting the salt is not needed
  ## @params As requried by save method
  my $self = shift;
  $self->reset_salt;
  return $self->save(@_);
}

#############################
####                     ####
####    LOGIN METHODS    ####
####                     ####
#############################

sub get_local_login {
  ## Gets the local login object related to the user
  ## @return Login object if found
  return shift @{shift->find_logins('query' => ['type' => 'local'])};
}

##################################
####                          ####
####    MEMBERSHIP METHODS    ####
####                          ####
##################################

sub get_membership_object {
  ## Gets membership object related to a given group
  ## @param Group object or id of the group
  ## @param Hashref to go as arguments to find_memberships method after adding 'group_id' and 'limit' to it
  ## @return Membership object, if found, undef otherwise
  my ($self, $group, $params) = @_;
  my $group_id = ref $group ? $group->group_id : $group or return undef;
  push @{$params->{'query'} ||= []}, 'group_id', $group_id;
  return shift @{$self->find_memberships(%$params, 'limit' => 1)};
}

sub admin_memberships {
  ## Gets all the admin memberships for the user
  return shift->find_memberships('with_objects' => 'group', 'query' => ['level' => 'administrator', 'status' => 'active', 'member_status' => 'active', 'group.status' => 'active']);
}

sub nonadmin_memberships {
  ## Gets all the non-admin memberships for the user
  return shift->find_memberships('query' => ['level' => 'member', 'status' => 'active', 'member_status' => 'active', '!group.type' => 'hidden']);
}

sub active_memberships {
  ## Gets all the active memberships (along with the related active groups) for the user
  return shift->find_memberships('with_objects' => 'group', 'query' => ['status' => 'active', 'member_status' => 'active', 'group.status' => 'active', '!group.type' => 'hidden' ]);
}

sub accessible_memberships {
  ## Gets all the active memberships (together with inactive groups for admin user) (along with the related active groups)
  return shift->find_memberships('with_objects' => 'group', 'query' => ['or' => ['level' => 'administrator', and => [ 'group.status' => 'active', '!group.type' => 'hidden' ]], 'status' => 'active', 'member_status' => 'active']);
}

sub create_new_membership_with_group {
  ## Creates a membership and group with the given details
  ## @param Hashref with keys as column (and relationships) for the membership object
  ## @return Memberhsip object with a new group (not yet saved to the database)
  my ($self, $params) = @_;

  return $self->create_membership_object({
    'level'         => 'administrator',
    'group'         => { 'status' => 'active' },
    %{$params || {}}    
  });
}

sub create_membership_object {
  ## Creates a membership with the given details
  ## @param Hashref with keys as column (and relationships) for the membership object
  ## @return Memberhsip object (not yet saved to the database)
  my ($self, $params) = @_;

  return ($self->add_memberships([{
    'level'         => 'member',
    'user_id'       => $self->user_id,  # this saves an extra step of calling save on the user object to actually link the objects
    'status'        => 'active',
    'member_status' => 'active',
    %{$params || {}}
  }]))[0];
}

#####################
###               ###
### GROUP METHODS ###
###               ###
#####################

sub is_member_of {
  ## Checks whether user is a member of the given group
  ## @param Group rose object or id of the group
  ## @return 1 or undef accordingly
  my ($self, $group) = @_;
  my $membership = $self->get_membership_object($group, {'query' => ['status' => 'active', 'member_status' => 'active']});
  return !!$membership;
}

sub is_admin_of {
  ## Checks whether user is an admin of the given group
  ## @param Group rose object or id of the group
  ## @return 1 or undef accordingly
  my ($self, $group) = @_;
  my $membership = $self->get_membership_object($group, {'query' => ['status' => 'active', 'member_status' => 'active', 'level' => 'administrator']});
  return !!$membership;
}

sub is_nonadminmember_of {
  ## Checks whether user is non-admin member of the given group
  ## @param Group rose object or id of the group
  ## @return 1 or undef accordingly
  my ($self, $group) = @_;
  my $membership = $self->get_membership_object($group, {'query' => ['status' => 'active', 'member_status' => 'active', 'level' => 'member']});
  return !!$membership;
}

1;
