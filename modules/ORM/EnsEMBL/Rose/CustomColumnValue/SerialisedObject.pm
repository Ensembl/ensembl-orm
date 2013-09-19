package ORM::EnsEMBL::Rose::CustomColumnValue::SerialisedObject;

use strict;
use warnings;

use Storable                qw(nfreeze thaw);
use IO::Uncompress::Gunzip  qw(gunzip $GunzipError);
use IO::Compress::Gzip      qw(gzip $GzipError);

use ORM::EnsEMBL::Utils::Exception;

use base qw(ORM::EnsEMBL::Rose::CustomColumnValue);

sub inflate {
  ## Abstract method implementation
  my $self    = shift;
  my $value   = $self->{'value'};
  my $column  = $self->{'column'};

  if (defined $value && !ref $value) {
    if ($column->gzip) {
      my $uncompressed_value;
      unless (gunzip \$value => \$uncompressed_value) {
        throw("Failed gunzip: $GunzipError");
      }
      $value = $uncompressed_value;
    }
    $value = thaw($value);
  }

  return $value;
}

sub deflate {
  ## Abstract method implementation
  my $self    = shift;
  my $value   = $self->{'value'};
  my $column  = $self->{'column'};

  if (defined $value && ref $value) {
    $value = nfreeze($value);
    if ($column->gzip) {
      my $compressed_value;
      unless (gzip \$value => \$compressed_value, -LEVEL => 9) {
        throw("Failed gzip: $GzipError");
      }
      $value = $compressed_value;
    }
  }

  return $value;
}

1;
