package ORM::EnsEMBL::DB::Tools::Object::Result;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'result',
  auto_initialize => []
);

__PACKAGE__->meta->serialised_object_columns({'name' => 'result_data', 'gzip' => 1});

1;
