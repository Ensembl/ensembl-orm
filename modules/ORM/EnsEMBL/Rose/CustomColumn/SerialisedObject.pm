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

package ORM::EnsEMBL::Rose::CustomColumn::SerialisedObject;

### Class for column type 'serialised_object' for saving a Perl objects to the db
### An extra boolean key 'gzip' is required (defaults to value being false) to compress the data when saving to db

use strict;
use warnings;

use ORM::EnsEMBL::Rose::CustomColumnValue::SerialisedObject;

use base qw(
  ORM::EnsEMBL::Rose::CustomColumn
  Rose::DB::Object::Metadata::Column::Blob
);

sub new {
  ## Creates new from existing or from the given params
  my $class = shift;
  my $self  = $class->new_from_existing(@_) || $class->SUPER::new(@_);

  return $self->init_custom_column;
}

sub allowed_base_classes {
  ## Abstract method implementation
  return qw(Rose::DB::Object::Metadata::Column::Scalar);
}

sub value_class {
  ## Abstract method implementation
  return 'ORM::EnsEMBL::Rose::CustomColumnValue::SerialisedObject';
}

sub type {
  ## Abstract method implementation
  return 'serialised_object';
}

sub gzip {
  ## Sets/Gets gzip flag on the column
  ## @param Flag value
  ##  - If on, stringified value will get gzipped before saving into the db, and will get gunzipped while retrieving
  ##  - If off, no compression is applied
  my $self = shift;
  $self->{'_ens_gzip'} = shift @_ ? 1 : 0 if @_;
  return $self->{'_ens_gzip'} || 0;
}

1;
