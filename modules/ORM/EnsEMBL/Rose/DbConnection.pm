package ORM::EnsEMBL::Rose::DbConnection;

### NAME: ORM::EnsEMBL::Rose::DbConnection
### Subclass of Rose::DB, a wrapper around DBI to provide some default

use strict;
use warnings;

use base qw(Rose::DB);

__PACKAGE__->use_private_registry;      ## Use a private registry for this class
__PACKAGE__->default_domain('ensembl'); ## Set the default domain

sub register_database {
  ## Adds db configurations to the registery
  ## @param Hashref with following keys
  ##  - database Database name
  ##  - host     Database server address
  ##  - port     Port number (default to 3306)
  ##  - username Database user name
  ##  - password Passowrd
  ##  - driver   Database driver type (defaults to mysql)
  ##  - type     Type as specified in individual rose objects
  my ($self, $params) = @_;

  return $self->register_db(qw(port 3306 driver mysql domain ensembl), %$params);
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
