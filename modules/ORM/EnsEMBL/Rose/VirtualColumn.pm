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

package ORM::EnsEMBL::Rose::VirtualColumn;

### Class to represent a virtual column which in actual is a key of a hash which is saved in a column as string
### It does not inherit rose's column object but has some similar methods

use strict;
use warnings;

use ORM::EnsEMBL::Utils::Helper qw(add_method);

use overload qw("" name);

sub new {
  ## @constructor
  ## @params Hashref with keys:
  ##  - name:     actual key name
  ##  - column:   Column object containing this virtual column
  ##  - alias:    alternative name to be used as a method name for rose object if key name is reserved in rose
  ##  - parent:   Meta class of the rose object
  ##  - default:  Default value
  my ($class, $params) = @_;
  return bless $params, $class;
}

sub type                  { return 'virtual';                                               }
sub name                  { return shift->{'name'};                                         }
sub column                { return shift->{'column'};                                       }
sub alias                 { return shift->{'alias'};                                        }
sub parent                { return shift->{'parent'};                                       }
sub default_exists        { return exists $_[0]->{'default'} && defined $_[0]->{'default'}; }
sub delete_default        { return shift->{'default'} = undef;                              }
sub accessor_method_name  { return $_[0]->{'alias'} || $_[0]->{'name'};                     }
sub mutator_method_name   { return shift->accessor_method_name;                             }

sub default {
  ## Sets/Gets the default value of the virtual column
  my $self = shift;
  $self->{'default'} = shift if @_;
  return $self->{'default'};
}

sub make_methods {
  ## Creates the method to access/modify the value from the rose object
  my $self = shift;

  add_method($self->parent->class, $self->accessor_method_name, sub {
    return shift->virtual_column_value($self, @_);
  });
}

1;
