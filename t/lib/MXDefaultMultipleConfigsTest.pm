package MXDefaultMultipleConfigsTest;
use Mouse;

extends 'MXDefaultConfigTest';

has '+configfile' => ( default => sub { [ 'test.yaml' ] } );

no Mouse;
1;
