package ORM::EnsEMBL::DB::VegaProduction::Object::Severity;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'severity',
  columns => [
    severity_id  => { type => 'serial', primary_key => 1, not_null => 1 },
    code         => { type => 'varchar', length => 40  },
    properties   => { type => 'text' },
    description  => { type => 'text' },
    user         => { type => 'varchar', length => 40  },
    date         => { type => 'datetime' },
  ],

  relationships => [
    rule => {
      type => 'one to many',
      class => 'ORM::EnsEMBL::DB::VegaProduction::Object::Rule',
      key_columns => { severity_id => 'severity_id' },
    },
  ],
);

1;

