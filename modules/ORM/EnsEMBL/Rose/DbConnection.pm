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

package ORM::EnsEMBL::Rose::DbConnection;

### Subclass of Rose::DB, a wrapper around DBI to provide some default

use strict;
use warnings;

use ORM::EnsEMBL::Rose::DbEntry;
use ORM::EnsEMBL::Utils::Exception;

use base qw(Rose::DB);

__PACKAGE__->use_private_registry;      ## Use a private registry for this class
__PACKAGE__->default_domain('ensembl'); ## Set the default domain

sub register_database {
  ## Adds db configurations to the registery
  ## @param Hashref with following keys
  ##  - database  Database name
  ##  - host      Database server address
  ##  - port      Port number (default to 3306)
  ##  - username  Database user name
  ##  - password  Passowrd
  ##  - driver    Database driver type (defaults to mysql)
  ##  - type      Type as specified in individual rose objects
  ##  - trackable Flag if off, will not respect the trackable info (on by default)
  my ($self, $params) = @_;

  return $self->register_db(ORM::EnsEMBL::Rose::DbEntry->new(qw(port 3306 driver mysql domain ensembl trackable 1), %$params));
}

sub trackable {
  ## Gets info about whether this database should respect the trackable info or not (readonly)
  ## Rose::DB calls this method to set the value in the first place (while instantiating this class) as specified in the register_db() arguments
  ## @return 1 or 0
  my $self    = shift;
  my $caller  = caller;
  $self->{'trackable'} = shift if @_ && $caller eq 'Rose::DB';
  return $self->{'trackable'};
}

sub dbi_connect {
  ## @override
  ## Overrides the default dbi_connect method to throw an exception if connection couldn't be established
  my ($self, @args) = @_;
  my $connection;
  try {
    $connection = $self->SUPER::dbi_connect(@args);
  } catch {
    warn $_;
  };
  throw('Database connection could not be created.') unless $connection;
  return $connection;
}

sub register_from_speciesdefs {
  ## Registers data sources from species defs
  ## @param EnsEMBL::Web::SpeciesDefs object
  my ($self, $sd) = @_;

  my $return = {};

  $sd->set_userdb_details_for_rose if $sd->can('set_userdb_details_for_rose');

  while (my ($key, $value) = each %{$sd->ENSEMBL_ORM_DATABASES}) {

    my $params = $value;
    if (!ref $params) {
      $params = $sd->multidb->{$value} or warn "Database connection properties for '$value' could not be found in SiteDefs" and next;
      $params = {
        'database'  => $params->{'NAME'},
        'host'      => $params->{'HOST'} || $sd->DATABASE_HOST,
        'port'      => $params->{'PORT'} || $sd->DATABASE_HOST_PORT,
        'username'  => $params->{'USER'} || $sd->DATABASE_WRITE_USER,
        'password'  => $params->{'PASS'} || $sd->DATABASE_WRITE_PASS,
      };
    }

    $params->{'type'} = $key;

    $return->{$key} = $self->register_database($params);
  }
  
  return $return;
}

1;
