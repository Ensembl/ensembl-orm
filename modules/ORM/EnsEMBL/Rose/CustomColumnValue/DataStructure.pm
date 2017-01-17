=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2017] EMBL-European Bioinformatics Institute

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

package ORM::EnsEMBL::Rose::CustomColumnValue::DataStructure;

## Class representing the value provided to column type 'datastructure'
## Purpose of this class is to stringify the datastructure if it's being used as a string, and keep it in a reference otherwise

use strict;
use warnings;

use Clone qw(clone);
use Scalar::Util qw(blessed);
use Data::Dumper;

use ORM::EnsEMBL::Utils::Exception;
use ORM::EnsEMBL::Utils::Helper qw(load_package);

use parent qw(ORM::EnsEMBL::Rose::CustomColumnValue);

use overload (
  '""'  => 'to_string',
  'cmp' => sub { my ($a, $b) = @_; return "$a" cmp "$b"; },
  'ne'  => sub { my ($a, $b) = @_; return "$a" ne  "$b"; },
  'eq'  => sub { my ($a, $b) = @_; return "$a" eq  "$b"; },
);

sub new {
  ## @constructor
  ## @override
  ## @param datastructure (possibly unparsed stringified)
  ## @param Column object
  ## @return Can return a blessed hash or a blessed array or a blessed scalar ref depending upon the argument provided
  ## @exception In case problem parsing the datastructure
  my ($class, $value, $column) = @_;

  return $value if UNIVERSAL::isa($value, $class);

  if (defined $value) {
    if (ref $value) {
      $value = clone($value);
    } else {
      my $error = '';
      $value = _parse("$value", $column->trusted, \$error);
      throw($error) if $error; # if any error in parsing
    }
  } else {
    $value = {};
  }

  $value = \"$value" unless ref $value;
  return bless $value, $class;
}

sub inflate {
  ## Abstract method implementation
  ## The inflated value of type datastructure is the instance if this class itself
  return shift;
}

sub deflate {
  ## Abstract method implementation
  my $self  = shift;
  my $value = $self->to_string;
  return $value eq '' || $value eq '{}' ? undef : $value; # returning undef prevents adding anything in the 'text' type column in case of null value
}

sub to_string {
  ## Stringifies the datastructure
  ## @return String
  my $self = shift;
  return Data::Dumper->new([ _recursive_unbless($self->raw) ])->Sortkeys(1)->Useqq(1)->Terse(1)->Indent(0)->Maxdepth(0)->Dump;
}

sub raw {
  ## Gets the actual hash/array/string blessed to form this object
  ## Any change to the output hash will not change the related rose object
  ## @return ArrayRef/HashRef or String, depedning upon the actual object
  my $self = shift;

  return "$$self" if $self->isa('SCALAR');
  return { map clone($_), %$self } if $self->isa('HASH');
  return [ map clone($_), @$self ] if $self->isa('ARRAY');
}

sub type {
  ## Gets the type of this object
  ## @return ARRAY/HASH or SCALAR, depedning upon the actual object
  my $self = shift;

  $self->isa($_) and return $_ for qw(SCALAR HASH ARRAY);
}

sub _parse {
  ## @private
  ## @function
  ## Parses a datastructure
  ## If data is not from a trusted source, it tries to check its validity before evaling it
  my ($str, $trusted, $error_ref) = @_;

  if (!$trusted) { # do validation check for the string before 'eval'ing it if it's not trusted
    my $str_copy = $str;

    ## Save the offsets of all the single or double qoutes, find the strings in the datastructure and save them.
    my (@strings, @offsets, $last);
    push @offsets, [ $2, $-[2], $1 ] while $str =~ /(\\*)(\'|\")/g;

    for (@offsets) {
      if (!$last) {
        $$error_ref = "Unexpected quote found at $_->[1] in datastructure: $str_copy" and return if length($_->[2]) % 2;
        $last       = $_ and next;
      }
      next if length($_->[2]) % 2;
      if ($last->[0] eq $_->[0]) {
        my $pos     = $last->[1] + 1;
        my $substr  = substr($str, $pos, $_->[1] - $pos);
        my $length  = length($substr);
        push @strings, [ $substr, $pos, $length, $_->[0] ];
        $last = undef;
      }
    }

    ## If odd number of quotes
    $$error_ref = "Unbalanced quote found at index $last->[1] in the datastructure: $str_copy" and return if $last;

    ## Replace the strings temporarily with number (index from lookup)
    my $i = $#strings;
    substr($str, $_->[1] - 1, $_->[2] + 2) = sprintf '%s%s%1$s', $_->[3], $i-- for reverse @strings;

    ## Wrap the unquoted hash keys with single quotes
    my $str_1 = $str;
    my $str_2 = $str;
    my $j     = 0;
    while ($str_1 =~ /[\{\,]{1}[\n\s\t]*(\'|\"?)([^\n\s\t\']+)(\'|\"?)[\n\s\t]*\=>/g) {
      next if $1;
      substr($str,   $-[2] + $j++ * 2, length $2) = qq('$2');
      substr($str_2, $-[2],            length $2) = ' ' x length $2;
    }

    ## If any unquoted string still remaining, throw exception
    if ($str_2 =~ /([a-z]+)/i) {
      $1 eq 'undef' or $$error_ref = "Unquoted string '$1' found in the datastructure: $str_copy" and return;
    }

    ## all checks done, now substitute the strings back in
    $str_1  = $str;
    $last   = 0;
    while ($str_1 =~ /((\"|\')([0-9]+)(\"|\'))/g) {
      my $qstr = sprintf '%s%s%1$s', $2, $strings[$3][0];
      substr($str, $-[1] + $last, length $1) =  $qstr;
      $last += length($qstr) - length $1;
    }
  }

  # finally - safe eval
  my $data = eval "$str";

  ## if eval threw an exception
  $$error_ref = $@ and return if $@;

  try {
    $data = _recursive_bless($data);
  } catch {
    $$error_ref = $_->message;
  };

  return if $$error_ref;

  return $data;
}

sub _recursive_unbless {
  ## @private
  ## @function
  ## Returns a string representation of an object (after unblessing all blessed objects) as it should go in the db
  my $obj = shift;

  return $obj unless ref $obj;

  my $encoded = blessed $obj ? [ '_ensorm_blessed_object', ref $obj ] : [];

  if (UNIVERSAL::isa($obj, 'HASH')) {
    push @$encoded, { map _recursive_unbless($_), %$obj };
  } elsif (UNIVERSAL::isa($obj, 'ARRAY')) {
    push @$encoded, [ map _recursive_unbless($_), @$obj ];
  } else { # scalar ref
    push @$encoded, $$obj;
  }

  $encoded = $encoded->[0] if @$encoded == 1;

  return $encoded;
}

sub _recursive_bless {
  ## @private
  ## @function
  ## Converts the encoded unblessed objects back to blessed objects
  ## @exception - if load_package throws one
  my $obj = shift;

  return $obj unless ref $obj;

  my ($class, $decoded);

  if (ref $obj eq 'ARRAY' && @$obj && $obj->[0] eq '_ensorm_blessed_object') {
    $class  = load_package($obj->[1]);
    $obj    = $obj->[2];
  }

  if (ref $obj eq 'ARRAY') {
    $decoded = [ map _recursive_bless($_), @$obj ];
  } elsif (ref $obj eq 'HASH') {
    $decoded = { map _recursive_bless($_), %$obj };
  } else {
    $decoded = $class ? \$obj : $obj;
  }

  return $class ? bless $decoded, $class : $decoded;
}

1;
