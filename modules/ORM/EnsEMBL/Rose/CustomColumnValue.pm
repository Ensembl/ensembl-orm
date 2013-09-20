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
