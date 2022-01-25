=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2022] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::DB::Accounts::Object::Membership;

### NAME: ORM::EnsEMBL::DB::Accounts::Object::Membership
### ORM class for the group_member table in ensembl_web_user_db

### Status of the membership is decided by two columns: status and member_status
### status      member_status
### -------------------------
### active      active          Membership is active
### active      pending         Invitation is waiting user's approval
### active      barred          User blocked the group - he will not receive any invitations but can still send a request to join the group - he can also unblock the group be setting member_status to inactive
### pending     active          User sent a request to join the group for admin's approval
### barred      active          User blocked by the group's admin. User can not send any request for joining group - Admin can send an invitation to the user, or can unblock the user by setting status to inactive
### inactive    inactive        Either user himself, or the admin removed the user from the group - user can still send a request or recieve an invitation

### any other combinations should not be allowed

### A membership record once created never gets removed from the db - either of the status or member_status can be inactive for the record to appear removed

### level column can contain three values:
### member: A normal member of the group - can share stuff with the group like bookmarks, annotations etc
### administrator: Can send invitations, accept/reject requests, edit the group and in-activate/re-activate the group

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Accounts::Object);

## Define schema
__PACKAGE__->meta->setup(
  table                 => 'group_member',

  columns               => [
    group_member_id       => {type => 'serial', primary_key => 1, not_null => 1},
    webgroup_id           => {type => 'integer', 'alias' => 'group_id'},
    user_id               => {type => 'integer'},
    level                 => {type => 'enum', 'values' => [qw(member administrator)],           'default' => 'member'  },
    status                => {type => 'enum', 'values' => [qw(active inactive pending barred)], 'default' => 'active'  },  #status set by the admin
    member_status         => {type => 'enum', 'values' => [qw(active inactive pending barred)], 'default' => 'inactive'},  #status set by the user
    data                  => {type => 'datamap'}
  ],

  trackable             => 1,

  virtual_columns       => [
    notify_edit           => {column => 'data', default => 0},
    notify_share          => {column => 'data', default => 0},
    notify_join           => {column => 'data', default => 1},
  ],

  relationships         => [
    user                  => {
      'type'                => 'many to one',
      'class'               => 'ORM::EnsEMBL::DB::Accounts::Object::User',
      'column_map'          => {'user_id' => 'user_id'},
    },
    group                 => {
      'type'                => 'many to one',
      'class'               => 'ORM::EnsEMBL::DB::Accounts::Object::Group',
      'column_map'          => {'webgroup_id' => 'webgroup_id'},
    }
  ]
);

sub is_active {
  ## Checks whether both status and member_status are active
  my $self = shift;
  return $self->status eq 'active' && $self->member_status eq 'active';
}

sub is_inactive {
  ## Checks whether either status or member_status is inactive
  my $self = shift;
  return $self->status eq 'inactive' || $self->member_status eq 'inactive';
}

sub is_group_blocked {
  ## Checks whether the group is blocked by the user
  return shift->member_status eq 'barred';
}

sub is_user_blocked {
  ## Checks whether the user is blocked by the group
  return shift->status eq 'barred';
}

sub is_pending_invitation {
  ## Checks whether this membership is a pending invitation for the user
  my $self = shift;
  return $self->member_status eq 'pending';
}

sub is_pending_request {
  ## Checks whether this membership is a pending request by the user
  my $self = shift;
  return $self->status eq 'pending';
}

sub make_invitation {
  ## Modifies the status and member_status to make it an invitation for the user
  my $self = shift;
  $self->status('active');
  $self->member_status('pending');
  $self->level('member');
}

sub make_request {
  ## Modifies the status and member_status to make it a request from user
  my $self = shift;
  $self->status('pending');
  $self->member_status('active');
  $self->level('member');
}

sub activate {
  ## Modifies the status and member_status to make user status active
  my $self = shift;
  $self->status('active');
  $self->member_status('active');
  $self->level('member');
}

sub inactivate {
  ## Modifies the status and member_status to make user status inactive
  my $self = shift;
  $self->status('inactive');
  $self->member_status('inactive');
  $self->level('member');
}

sub block_user {
  ## Modifies the status and member_status to block the user
  my $self = shift;
  $self->status('barred');
  $self->member_status('active');
  $self->level('member');
}

sub block_group {
  ## Modifies the status and member_status to block the group
  my $self = shift;
  $self->status('active');
  $self->member_status('barred');
  $self->level('member');
}

1;