=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2021] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::CustomColumn::DataStructure;

### Class for column type 'datastructure' for saving a Hash or Array
### An extra boolean key 'trusted' is required (defaults to value being false) to initiate the column during AnyRoseObject->meta->setup (see &trusted below)

use strict;
use warnings;

use ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure;

use parent qw(
  ORM::EnsEMBL::Rose::CustomColumn
  Rose::DB::Object::Metadata::Column::Text
);

sub new {
  ## Creates new from existing or from the given params
  my $class = shift;
  my $self  = $class->new_from_existing(@_) || $class->SUPER::new(@_);

  return $self->init_custom_column;
}

sub allowed_base_classes {
  ## Abstract method implementation
  return qw(Rose::DB::Object::Metadata::Column::Text);
}

sub value_class {
  ## Abstract method implementation
  return 'ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure';
}

sub type {
  ## Abstract method implementation
  return 'datastructure';
}

sub trusted {
  ## Sets/Gets trusted flag on the column
  ## If the column value is trusted to be safely 'eval'able, keep this flag on
  ## @param Flag value
  ##  - If on, string value is 'eval'ed straight without any security validation before setting it as a value of this column (insure but faster)
  ##  - If off, value is set to this column after validation checks (secure but slower)
  my $self = shift;
  $self->{'_ens_trusted'} = shift @_ ? 1 : 0 if @_;
  return $self->{'_ens_trusted'} || 0;
}

1;
