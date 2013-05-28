package ORM::EnsEMBL::DB::Tools::Object::Analysis;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table       => 'analysis_object',

  columns     => [
    ticket_id   => {type => 'int', length => 10, primary_key => 1, not_null => 1},
    modified_at   => {type => 'timestamp', not_null => 1},
    object      => {type =>'blob', not_null =>1},
  ],
  
  relationships => [
    ticket  => {
      type       => 'one to one',
      class      => 'ORM::EnsEMBL::DB::Tools::Object::Ticket',
      column_map => {'ticket_id' => 'ticket_id'},
    },
  ],

);

1;

