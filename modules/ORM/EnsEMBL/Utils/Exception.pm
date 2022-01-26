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

package ORM::EnsEMBL::Utils::Exception;

use strict;
use warnings;

use Carp qw(longmess);

use overload qw("" to_string);

sub import {
  ## Imports the try, catch and throw function to the calling package
  my $class  = shift;
  my $caller = caller;

  {
    # import functions
    no strict qw(refs);

    *{"${caller}::try"} = sub (&$) {
      my ($try, $catch) = @_;
      eval { &$try };
      if ($@) {
        local $_ = $class->new($@);
        $@ = undef;
        &$catch;
      }
    };

    *{"${caller}::catch"} = sub (&) {
      shift;
    };

    *{"${caller}::throw"} = sub {
      die $class->new(@_);
    };
  }
}

sub new {
  my ($class, $message) = @_;

  local $Carp::MaxArgNums = -1;

  return bless ref $message ? $message : {
    'type'    => 'ORMException',
    'message' => $message  || '',
    'stack'   => longmess
  }, $class;
}

sub to_string {
  my $self = shift;
  return sprintf "Uncaught exception '%s' with message '%s'\n  %s", $self->type, $self->{'message'}, $self->{'stack'};
}


sub type {
  return shift->{'type'};
}

sub message {
  return shift->{'message'};
}

1;
