=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::CustomColumn::DataMap;

### Class for column type 'datamap' corresponding to single dimensional Hash
### Together with ORM::EnsEMBL::Rose::VirtualColumn, this package enables to access keys of this column as method names to the actual rose object

### Reserved keys:
### Since keys for the datamap can be accessed as methods on the rose object, any method name that is reserved in the rose object should be provided an 'alias' name

### Example:
### package MyObject;
### use parent qw(Rose::DB::Object);
### __PACKAGE__->meta->setup(
###   columns => [
###     'data'  => {'type' => 'datamap', 'trusted' => 1, 'not_null' => 1} # trusted specifies that the value can always be trusted to eval into a hash without any errors
###   ],
###   virtual_columns => [
###     'name'  => {'column' => 'data'},
###     'db'    => {'column' => 'data', 'alias' => 'data_db'} # this column will be accessible by method 'data_db' not 'db'
###   ]
### );

use strict;
use warnings;

use ORM::EnsEMBL::Rose::CustomColumnValue::DataMap;

use parent qw(ORM::EnsEMBL::Rose::CustomColumn::DataStructure);

sub init_custom_column {
  ## @override
  ## Adds 'on_get' trigger to the column to set default values of the virtual columns
  my $self = shift->SUPER::init_custom_column;

  $self->add_trigger(
    'event' => 'on_get',
    'name'  => 'set_defaults',
    'code'  => sub {
      my ($object, $value) = @_;
      $value = $self->value_class->new($value, $self);
      $self->set_default_values($value);
      return $value;
    }
  );

  return $self;
}

sub set_default_values {
  ## Sets default values to the virtual columns
  ## @param Inflated value
  my ($self, $value) = @_;
  for ($self->parent->virtual_columns) {
    if ($_->column eq $self && $_->default_exists) {
      my $current_val = $value->{$_};
      my $default_val = $_->default;
      $value->{$_} = $default_val if !defined $current_val || $current_val eq '' && $default_val ne '';
    }
  }
}

sub value_class {
  ## Abstract method implementation
  return 'ORM::EnsEMBL::Rose::CustomColumnValue::DataMap';
}

sub type {
  ## Abstract method implementation
  return 'datamap';
}

1;
