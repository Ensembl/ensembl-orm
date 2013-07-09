package ORM::EnsEMBL::DB::Production::Object::Biotype;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table       => 'biotype',

  columns     => [
    biotype_id        => {type => 'serial', primary_key => 1, not_null => 1}, 
    name              => {type => 'varchar', 'length' => 64 },
    is_current        => {type => 'integer', default => 1, not_null => 1},
    is_dumped         => {type => 'integer', default => 1, not_null => 1},
    object_type       => {type => 'enum', default => 'gene', not_null => 1, 'values' => [qw(gene transcript)]},
    db_type           => {type => 'set' , default => 'core', not_null => 1, 'values' => [qw(
                            cdna
                            core
                            coreexpressionatlas
                            coreexpressionest
                            coreexpressiongnf
                            funcgen
                            otherfeatures
                            presite
                            rnaseq
                            sangervega
                            variation
                            vega)]
    },
    attrib_type_id    => {type => 'integer'},
    description       => {type => 'text'},
    biotype_group     => {type => 'enum', default => 'undefined', not_null => 1, 'values' => [qw(
                            coding
                            pseudogene
                            short_noncoding
                            long_noncoding
                            undefined)]
    }
  ],

  trackable             => 1,

  title_column          => 'name',

  inactive_flag_column  => 'is_current',

  relationships => [
    attrib_type       => {
      'type'        => 'one to one',
      'class'       => 'ORM::EnsEMBL::DB::Production::Object::AttribType',
      'column_map'  => {'attrib_type_id' => 'attrib_type_id'},
    }
  ]
);

1;
