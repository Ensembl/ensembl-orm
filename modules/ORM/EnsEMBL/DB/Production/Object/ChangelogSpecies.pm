=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package ORM::EnsEMBL::DB::Production::Object::ChangelogSpecies;

use strict;
use warnings;

use parent qw(ORM::EnsEMBL::DB::Production::Object);

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