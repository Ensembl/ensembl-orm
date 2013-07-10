package ORM::EnsEMBL::DB::Tools::Object::JobType;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table       => 'job_type',

  columns     => [
    job_type_id => {type => 'tinyint', primary_key => 1, not_null=>1},
    job_type    => {type => 'varchar', length => 10, not_null => 1, 'alias' => 'name'},
    job_name    => {type => 'varchar', length => 32, not_null => 1, 'alias' => 'caption'},
  ],

  relationships => [
    ticket => {
      type        => 'one to one',
      class       => 'ORM::EnsEMBL::DB::Tools::Object::Ticket', 
      column_map  => {'job_type_id' => 'job_type_id'},
    },
  ],
);

1;

