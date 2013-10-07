package ORM::EnsEMBL::Utils::Helper;

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);
use Exporter    qw(import);

use ORM::EnsEMBL::Utils::Exception;

our @EXPORT_OK = qw(load_package add_method random_string encrypt_password);

sub load_package {
  ## Loads ('require', not 'use') a package with the given name
  ## @param Class name
  ## @return Class name if successfully loaded
  ## @exception If class could not be loaded
  my $classname = shift;
  throw('Module name is missing') unless $classname;
  eval "require $classname";
  throw("Module '$classname' could not be loaded: $@") if $@;
  return $classname;
}

sub add_method {
  ## Dynamically adds a method to a class
  ## @param  Class (or object instance of the class)
  ## @params List of method name and subroutine code (can be multiple)
  my $class = shift;
     $class = ref $class if ref $class;

  while (@_) {
    my ($method_name, $method) = splice @_, 0, 2;
    no strict qw(refs);
    *{"${class}::${method_name}"} = $method;
  }
}

sub random_string {
  ## Returns a random string of given length and constituting given characters only
  ## @param Length of the string (defaults to 8)
  ## @param Arrayref of characters that are allowed in the random string (optional)
  my $length  = (shift) + 0 || 8;
  my $random  = shift || ['a'..'z','A'..'Z','0'..'9','_'];

  return join '', map { $random->[ rand @$random ] } (1..$length);
}

sub encrypt_password {
  ## Returns encrypted password to be saved in the database
  ## @param Password string
  return md5_hex($_[0]);
}

1;
