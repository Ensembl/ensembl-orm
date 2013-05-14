package ORM::EnsEMBL::DB::Production::Object::ChangelogSpecies;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'changelog_species',

  columns     => [
    changelog_id      => {type => 'int', not_null => 1, primary_key => 1}, 
    species_id        => {type => 'int', not_null => 1, primary_key => 1}, 
  ],

  relationships => [
    changelog => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Changelog',
      'column_map'  => {'changelog_id' => 'changelog_id'},
    },
    species => {
      'type'        => 'many to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::Species',
      'column_map'  => {'species_id' => 'species_id'}
    },
  ],
);

1;