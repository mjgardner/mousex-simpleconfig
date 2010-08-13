package MXDefaultWithSubConfigTest;
use Moose;
with 'MooseX::SimpleConfig';

use Path::Class::File;

has 'direct_attr' => (is => 'ro', isa => 'Int');

has 'req_attr' => (is => 'rw', isa => 'Str', required => 1);

has '+configfile' => ( default => sub { [ 'test.yaml' ] } );
#has '+configfile' => ( default => 'test.yaml' );

no Moose;
1;
