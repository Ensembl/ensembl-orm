package ORM::EnsEMBL::DB::Production::Object::Changelog;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'changelog',

  columns     => [
    changelog_id          => {type => 'serial', primary_key => 1, not_null => 1}, 
    release_id            => {type => 'integer'},
    title                 => {type => 'varchar'},
    content               => {type => 'text'},
    notes                 => {type => 'text'},
    status                => {type => 'enum', 'values' => [qw(declared handed_over postponed cancelled)], 'default' => 'declared'},
    team                  => {type => 'enum', 'values' => [qw(Compara Core Funcgen EnsemblGenomes Genebuild Outreach Variation Web Wormbase Production)]},
    assembly              => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    gene_set              => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    repeat_masking        => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    stable_id_mapping     => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    affy_mapping          => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    biomart_affected      => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    variation_pos_changed => {type => 'enum', 'values' => [qw(N Y)], 'default' => 'N'},
    db_status             => {type => 'enum', 'values' => [qw(N/A unchanged patched new)], 'default' => 'N/A'},
    db_type_affected      => {type => 'set',  'values' => [qw(cdna core funcgen otherfeatures rnaseq variation vega)]},
    mitochondrion         => {type => 'enum', 'values' => [qw(Y N changed)], 'default' => 'N'},
    priority              => {type => 'integer', 'not_null' => 1, 'default' => 2},
    is_current            => {type => 'integer', 'not_null' => 1, 'default' => 1}
  ],

  trackable             => 1,

  title_column          => 'title',

  inactive_flag_column  => 'is_current',

  relationships         => [
    species => {
      'type'        => 'many to many',
      'map_class'   => 'ORM::EnsEMBL::DB::Production::Object::ChangelogSpecies',
      'map_from'    => 'changelog',
      'map_to'      => 'species'
    }
  ]
);

1;
