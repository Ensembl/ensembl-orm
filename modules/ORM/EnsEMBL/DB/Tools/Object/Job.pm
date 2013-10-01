package ORM::EnsEMBL::DB::Tools::Object::Job;

### Object representing 'job' table in the tools db
### Column description:
###  - status:
###     awaiting_hive_response: job sent to hive db, and waiting for any further updates from hive
###     awaiting_user_response: some problem happenned, either job could not be sent to hive, or has failed somewhere - user needs to have a look and resubmit it
###     done: job finished successfully, no further editing should be made to this job
###  - hive_status:
###     not_submitted: could not be sent to the hive
###     queued: sent to hive, but not submitted to LFS by hive (either hive is too busy, or beekeeper is down)
###     submitted: sent to hive and submitted to LFS (relax and wait)
###     running: running on LFS
###     done: done at LFS
###     failed: failed at hive or LFS
###     deleted: job got deleted from the hive db

use strict;
use warnings;

use ORM::EnsEMBL::DB::Tools::Object::JobMessage;  # for foreign key initialisation
use ORM::EnsEMBL::DB::Tools::Object::Result;      # for foreign key initialisation

use base qw(ORM::EnsEMBL::DB::Tools::Object);

__PACKAGE__->meta->setup(
  table           => 'job',
  auto_initialize => []
);

__PACKAGE__->meta->datastructure_columns(map {'name' => $_, 'trusted' => 1}, qw(job_data hive_job_data));

1;
