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
