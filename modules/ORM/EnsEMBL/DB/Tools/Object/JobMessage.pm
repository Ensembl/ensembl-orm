package ORM::EnsEMBL::DB::Tools::Object::JobMessage;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'job_message',
  auto_initialize => []
);

__PACKAGE__->meta->datastructure_columns(map {'name' => $_, 'trusted' => 1}, qw(exception data));

1;
