package ORM::EnsEMBL::DB::Production::Object::ExternalDb;

use strict;
use warnings;

use base qw(ORM::EnsEMBL::DB::Production::Object);

__PACKAGE__->meta->setup(
  table                 => 'master_external_db',

  columns               => [
    external_db_id        => {'type' => 'serial',   'not_null' => 1,  'length' => 5,     'primary_key' => 1},
    db_name               => {'type' => 'varchar',  'not_null' => 1,  'length' => 100},
    db_release            => {'type' => 'varchar',                    'length' => 255},
    status                => {'type' => 'enum',     'not_null' => 1,  'values' => [qw(KNOWNXREF KNOWN XREF PRED ORTH PSEUDO)]},
    priority              => {'type' => 'int',      'not_null' => 1,  'length' => 11},
    db_display_name       => {'type' => 'varchar',                    'length' => 255},
    type                  => {'type' => 'enum',                       'values' => [qw(ARRAY ALT_TRANS ALT_GENE MISC LIT PRIMARY_DB_SYNONYM ENSEMBL)]},
    secondary_db_name     => {'type' => 'varchar',                    'length' => 255},
    secondary_db_table    => {'type' => 'varchar',                    'length' => 255},
    description           => {'type' => 'text'}, 
    is_current            => {'type' => 'int',      'not_null' => 1,  'length' => 1,     'default' => 1}
  ],
  
  trackable             => 1,

  unique_key            => [qw(db_name is_current)],

  title_column          => 'db_name',

  inactive_flag_column  => 'is_current'
);

1;