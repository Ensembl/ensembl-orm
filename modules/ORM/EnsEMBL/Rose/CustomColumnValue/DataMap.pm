package ORM::EnsEMBL::Rose::CustomColumnValue::DataMap;

## Name: ORM::EnsEMBL::Rose::CustomColumnValue::DataMap
## Class representing the value provided to column type 'datamap'

use strict;

use ORM::EnsEMBL::Utils::Exception;

use base qw(ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure);

sub new {
  ## @overrides
  ## @constructor
  ## @exception If data is not a hash 
  my ($class, $data, $trusted) = @_;
  my $self = $class->SUPER::new($data || {}, $trusted);
  throw('Column of type datatype can only accept stringified hash values.') unless $self->isa('HASH');

  return $self;
}

sub has_key {
  ## Tells whether a key exists in the datamap or not
  ## @param String value of the key
  my ($self, $key) = @_;
  return exists $self->{$key};
}

1;
