package ORM::EnsEMBL::DB::VegaProduction::Object::Rulefunc;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::VegaProduction::Object);

__PACKAGE__->meta->setup(
  table => 'rulefunc',
  columns => [
    rulefunc_id  => { type => 'serial', primary_key => 1, not_null => 1 },
    name         => { type => 'varchar', length => 40  },
    func         => { type => 'text' },
    description  => { type => 'text' },
    user         => { type => 'varchar', length => 40  },
    date     => { type => 'datetime' },
  ],
);

1;

