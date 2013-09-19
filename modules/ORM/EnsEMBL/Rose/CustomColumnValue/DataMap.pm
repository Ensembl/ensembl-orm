package ORM::EnsEMBL::Rose::CustomColumnValue::DataMap;

## Class representing the value provided to column type 'datamap'

use strict;

use ORM::EnsEMBL::Utils::Exception;

use base qw(ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure);

sub new {
  ## @override
  ## @constructor
  ## @exception If data is not a hash 
  my ($class, $data) = splice @_, 0, 2;
  my $self = $class->SUPER::new($data || {}, @_);
  throw('Column of type datatype can only accept stringified hash values.') unless $self->isa('HASH');

  return $self;
}

sub deflate {
  ## @override
  ## Adds default values to the virtual keys before deflating the column value
  my ($self, $column) = splice @_, 0, 2;
  $column->set_default_values($self);
  return $self->SUPER::deflate($column, @_);
}

sub has_key {
  ## Tells whether a key exists in the datamap or not
  ## @param String value of the key
  my ($self, $key) = @_;
  return exists $self->{$key};
}

1;
