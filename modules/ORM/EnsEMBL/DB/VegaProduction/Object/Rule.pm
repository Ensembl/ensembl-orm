package ORM::EnsEMBL::DB::VegaProduction::Object::Rule;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'rule',
  columns => [
    rule_id  => { type => 'serial', primary_key => 1, not_null => 1 },
    'speciesstepset_id'
                => { type => 'int' },
    rule        => { type => 'text' },
    reason      => { type => 'text' },
    user        => { type => 'varchar', length => 40  },
    severity_id => { type => 'int' },
    priority    => { type => 'int' },
    date        => { type => 'datetime' },
  ],

  relationships => [
    speciesstepset => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Speciesstepset',
      key_columns => { speciesstepset_id => 'speciesstepset_id' },
    },
    severity => {
      type => 'many to one',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Severity',
      key_columns => { severity_id => 'severity_id' },
    },
  ],
);

1;

