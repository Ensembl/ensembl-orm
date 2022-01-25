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

package ORM::EnsEMBL::Rose::CustomColumnValue;

### Abstract base class for custom column values

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Exception;

sub new {
  ## @constructor
  ## @param Value (inflated or deflated)
  ## @param Column (CustomColumn object)
  ## @param Object (actual Rose object)
  my ($class, $value, $column, $object) = @_;
  return UNIVERSAL::isa($value, $class) ? $value : bless {'value' => $value, 'column' => $column, 'object' => $object}, $class;
}

sub inflate {
  ## @abstract
  ## @param Column (CustomColumn object)
  ## @param Object (actual Rose object)
  ## Should convert the value saved in the db to the required object form
  ## This method will be called as soon as the data is returned from the db
  throw('Abstract method not implemented');
}

sub deflate {
  ## @abstract
  ## @param Column (CustomColumn object)
  ## @param Object (actual Rose object)
  ## Should convert the value to the form that will be saved in the db
  ## This method will be called just before saving the data to the db
  throw('Abstract method not implemented');
}

1;
