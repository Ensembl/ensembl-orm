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
        local $_ = $@;
        local $@ = undef;
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
  return bless {
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
