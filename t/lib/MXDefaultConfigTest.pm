package MXDefaultConfigTestBase;
use Moose;

has 'inherited_ro_attr' => (is => 'ro', isa => 'Str');

no Moose;
1;

package MXDefaultConfigTest;
use Moose;
use Path::Class::File;
extends 'MXDefaultConfigTestBase';
with 'MooseX::SimpleConfig';

has 'direct_attr' => (is => 'ro', isa => 'Int');

has 'req_attr' => (is => 'rw', isa => 'Str', required => 1);

has '+configfile' => ( default => 'test.yaml' );

no Moose;
1;
