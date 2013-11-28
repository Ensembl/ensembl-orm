=head1 LICENSE

Copyright [1999-2013] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Accounts::Object::Group;

### NAME: ORM::EnsEMBL::DB::Accounts::Object::Group
### ORM class for the webgroup table in ensembl_web_user_db

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Accounts::Object::RecordOwner);

use constant RECORD_TYPE => 'group';

__PACKAGE__->meta->setup(
  table                 => 'webgroup',

  columns               => [
    webgroup_id           => { 'type' => 'serial', 'primary_key' => 1, 'not_null' => 1, 'alias' => 'group_id' },
    name                  => { 'type' => 'varchar', 'length' => '255' },
    blurb                 => { 'type' => 'text' },
    data                  => { 'type' => 'text' },
    type                  => { 'type' => 'enum', 'values' => [qw(open restricted private hidden)], 'default' => 'restricted' },
    status                => { 'type' => 'enum', 'values' => [qw(active inactive)], 'default' => 'active' }
  ],

  trackable             => 1,
  title_column          => 'name',
  inactive_flag_column  => 'status',
  inactive_flag_value   => 'inactive',

  relationships         => [
    memberships           => { 'type' => 'one to many', 'class' => 'ORM::EnsEMBL::DB::Accounts::Object::Membership', 'column_map' => {'webgroup_id' => 'webgroup_id'}, 'methods' => { map {$_, undef} qw(add_on_save count find get_set_on_save)} },
    records               => __PACKAGE__->record_relationship_params('webgroup_id')
  ],

  virtual_relationships => __PACKAGE__->record_relationship_types
);

sub id {
  ## Same as group_id
  return shift->group_id;
}

sub membership {
  ## Returns the membership object for the given user, creates a new membership object if no existing found
  ## @param Member - Rose User object
  ## @param User level (administrator or member) - defaults to 'member' - Only considered if new membership is being created
  ## @return Membership object, possibly a new unsaved one
  my ($self, $member, $level) = @_;
  my $membership = $member->get_membership_object($self);
  unless ($membership) {
    $membership = ($self->add_memberships([{
      'user_id'   => $member->user_id,
      'group_id'  => $self->group_id,
      'level'     => $level eq 'administrator' ? 'administrator' : 'member'
    }]))[0];
  }
  return $membership;
}

sub admin_memberships {
  ## Gets all the membership objects with administrator level
  ## @return Arrayref of membership objects
  my $self = shift;
  return my $memberships = $self->find_memberships('query' => ['level' => 'administrator', 'status' => 'active', 'member_status' => 'active', 'user.status' => 'active'], 'with_objects' => 'user');
}

1;