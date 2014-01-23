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

package ORM::EnsEMBL::DB::Accounts::Object::Login;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Accounts::Object);

use ORM::EnsEMBL::Utils::Helper qw(random_string encrypt_password);

__PACKAGE__->meta->setup(
  table           => 'login',

  columns         => [
    login_id        => {'type' => 'serial', 'primary_key' => 1, 'not_null' => 1},
    user_id         => {'type' => 'int', 'length'  => '11'},
    identity        => {'type' => 'varchar', 'length' => '255', 'not_null' => 1},
    type            => {'type' => 'enum', 'values' => [qw(local openid ldap)], 'not_null' => 1, 'default' => 'local'},
    data            => {'type' => 'datamap', 'length' => '1024'},
    status          => {'type' => 'enum', 'values' => [qw(active pending)], 'not_null' => 1, 'default' => 'pending'},
    salt            => {'type' => 'varchar', 'length' => '8'},
  ],

  trackable       => 1,

  virtual_columns => [
    provider        => {'column' => 'data'},
    password        => {'column' => 'data'},
    ldap_user       => {'column' => 'data'},
    email           => {'column' => 'data'},
    name            => {'column' => 'data'},
    organisation    => {'column' => 'data'},
    country         => {'column' => 'data'},
    subscription    => {'column' => 'data'}
  ],

  relationships   => [
    user            => {
      'type'          => 'many to one',
      'class'         => 'ORM::EnsEMBL::DB::Accounts::Object::User',
      'column_map'    => {'user_id' => 'user_id'},
    }
  ]
);

sub get_url_code {
  ## Creates a url code for a given login
  ## @return String
  my $self = shift;
  my $user = $self->user;

  return sprintf('%s-%s-%s', $user ? $user->user_id : '0', $self->login_id, $self->salt);
}

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

sub set_password {
  ## Encrypts the password before saving it to the object
  ## @param Unencrypted password string
  my ($self, $password) = @_;
  $self->password(encrypt_password($password));
}

sub verify_password {
  ## Checks a plain text password against an encrypted password
  ## @param Password string
  ## @return Boolean accordingly
  my ($self, $password) = @_;
  return encrypt_password($password) eq $self->password;
}

sub activate {
  ## Activates the login object after copying the information about user name, organisation, country it to the related user object (does not save to the database afterwards)
  ## @param User object (if not already linked to the login)
  my ($self, $user) = @_;
  if ($user) {
    $user->add_logins([ $self ]);
  } else {
    $user = $self->user;
  }
  $self->$_ and !$user->$_ and $user->$_($self->$_) for qw(name organisation country);

  $self->reset_salt;
  $self->status('active');
}

1;
