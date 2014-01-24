package ORM::EnsEMBL::DB::VegaProduction::Object::Species;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'species',
  columns => [
    species_id       => { type => 'serial', primary_key => 1, not_null => 1 },
    genome_status_id => { type => 'int' },
    scientific_name  => { type => 'varchar', length => 40 },
    production_name  => { type => 'varchar', length => 40 },
    display_name     => { type => 'varchar', length => 40 },
    common_name      => { type => 'varchar', length => 40 },
  ],

  unique_keys => ['scientific_name','production_name',
                  'display_name','common_name'],
  error_mode => 'return',
);

1;

