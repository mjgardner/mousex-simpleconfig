package MooseX::SimpleConfig;

use Moose::Role;
with 'MooseX::ConfigFromFile';

our $VERSION   = '0.03';

use Config::Any ();

sub get_config_from_file {
    my ($class, $file) = @_;

    my $can_config_any_args = $class->can('config_any_args');
    my %args = $can_config_any_args ?
        ( %{$can_config_any_args->($class, $file)}, files => [ $file ], use_ext => 1 ) :
        ( files => [ $file ], use_ext => 1 )
    ;
    my $raw_cfany = Config::Any->load_files(\%args);

    die q{Specified configfile '} . $file
        . q{' does not exist, is empty, or is not readable}
            unless $raw_cfany->[0]
                && exists $raw_cfany->[0]->{$file};

    my $raw_config = $raw_cfany->[0]->{$file};

    die "configfile must represent a hash structure"
        unless $raw_config && ref $raw_config && ref $raw_config eq 'HASH';

    $raw_config;
}

no Moose::Role; 1;

__END__

=pod

=head1 NAME

MooseX::SimpleConfig - A Moose role for setting attributes from a simple configfile

=head1 SYNOPSIS

  ## A YAML configfile named /etc/my_app.yaml:
  foo: bar
  baz: 123

  ## In your class 
  package My::App;
  use Moose;
  
  with 'MooseX::SimpleConfig';
  
  has 'foo' => (is => 'ro', isa => 'Str', required => 1);
  has 'baz'  => (is => 'rw', isa => 'Int', required => 1);
  
  # ... rest of the class here
  
  ## in your script
  #!/usr/bin/perl
  
  use My::App;
  
  my $app = My::App->new_with_config(configfile => '/etc/my_app.yaml');
  # ... rest of the script here

  ####################
  ###### combined with MooseX::Getopt:

  ## In your class 
  package My::App;
  use Moose;
  
  with 'MooseX::SimpleConfig';
  with 'MooseX::Getopt';
  
  has 'foo' => (is => 'ro', isa => 'Str', required => 1);
  has 'baz'  => (is => 'rw', isa => 'Int', required => 1);
  
  # ... rest of the class here
  
  ## in your script
  #!/usr/bin/perl
  
  use My::App;
  
  my $app = My::App->new_with_options();
  # ... rest of the script here

  ## on the command line
  % perl my_app_script.pl -configfile /etc/my_app.yaml -otherthing 123

=head1 DESCRIPTION

This role loads simple configfiles to set object attributes.  It
is based on the abstract role L<MooseX::ConfigFromFile>, and uses
L<Config::Any> to load your configfile.  L<Config::Any> will in
turn support any of a variety of different config formats, detected
by the file extension.  See L<Config::Any> for more details about
supported formats.

Like all L<MooseX::ConfigFromFile> -derived configfile loaders, this
module is automatically supported by the L<MooseX::Getopt> role as
well, which allows specifying C<-configfile> on the commandline.

=head1 ATTRIBUTES

=head2 configfile

Provided by the base role L<MooseX::ConfigFromFile>.  You can
provide a default configfile pathname like so:

  has +configfile ( default => '/etc/myapp.yaml' );

=head1 CLASS METHODS

=head2 new_with_config

Provided by the base role L<MooseX::ConfigFromFile>.  Acts just like
regular C<new()>, but also accepts an argument C<configfile> to specify
the configfile from which to load other attributes.  Explicit arguments
to C<new_with_config> will override anything loaded from the configfile.

=head2 get_config_from_file

Called internally by either C<new_with_config> or L<MooseX::Getopt>'s
C<new_with_options>.  Invokes L<Config::Any> to parse C<configfile>.

=head1 AUTHOR

Brandon L. Black, E<lt>blblack@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
