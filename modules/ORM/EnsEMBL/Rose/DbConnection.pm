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

  $self->register_db(qw(port 3306 driver mysql domain ensembl), %$params);
}

sub register_from_sitedefs {
  ## Registers data sources from site defs
  ## @param SiteDefs
  my ($self, $sd) = @_;
  while (my ($key, $details) = each %{$sd->ROSE_DB_DATABASES}) {

    my $params = $details;
    if (!ref $params) {
      $params = $sd->multidb->{$details} or warn "Database connection properties for '$details' could not be found in SiteDefs" and next;
      $params = {
        'database'  => $params->{'NAME'},
        'host'      => $params->{'HOST'} || $sd->DATABASE_HOST,
        'port'      => $params->{'PORT'} || $sd->DATABASE_HOST_PORT,
        'username'  => $params->{'USER'} || $sd->DATABASE_WRITE_USER,
        'password'  => $params->{'PASS'} || $sd->DATABASE_WRITE_PASS,
      };
    }

    $params->{'type'} = $key;

    $self->register_database($params);
  }
}

1;
