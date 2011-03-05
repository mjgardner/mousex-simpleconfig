package MouseX::SimpleConfig;

# ABSTRACT: A Mouse role for setting attributes from a simple configfile

use Carp;
use English '-no_match_vars';
use Mouse::Role;
with 'MouseX::ConfigFromFile';

use Config::Any ();

sub get_config_from_file {
    my ($class, $file) = @ARG;

    my $files_ref;
    given (ref $file) {
        when ('CODE')  { $file = $file->() }
        when ('ARRAY') { $files_ref = $file }
        default        { $files_ref = [$file] }
    }

    my $can_config_any_args = $class->can('config_any_args');
    my $extra_args = $can_config_any_args ?
        $can_config_any_args->($class, $file) : {};
    ;
    my $raw_cfany = Config::Any->load_files({
        %{$extra_args},
        use_ext         => 1,
        files           => $files_ref,
        flatten_to_hash => 1,
    } );

    my %raw_config;
    foreach my $file_tested ( reverse @{$files_ref} ) {
        if ( ! exists $raw_cfany->{$file_tested} ) {
            warn qq{Specified configfile '$file_tested' does not exist, } .
                qq{is empty, or is not readable\n};
                next;
        }

        my $cfany_hash = $raw_cfany->{$file_tested};
        croak "configfile must represent a hash structure in file: $file_tested"
            if not ($cfany_hash && ref $cfany_hash && ref $cfany_hash eq 'HASH');

        %raw_config = ( %raw_config, %{$cfany_hash} );
    }

    return \%raw_config;
}

no Mouse::Role; 1;

=head1 SYNOPSIS

  ## A YAML configfile named /etc/my_app.yaml:
  foo: bar
  baz: 123

  ## In your class
  package My::App;
  use Mouse;

  with 'MouseX::SimpleConfig';

  has 'foo' => (is => 'ro', isa => 'Str', required => 1);
  has 'baz'  => (is => 'rw', isa => 'Int', required => 1);

  # ... rest of the class here

  ## in your script
  #!/usr/bin/perl

  use My::App;

  my $app = My::App->new_with_config(configfile => '/etc/my_app.yaml');
  # ... rest of the script here

  ####################
  ###### combined with MouseX::Getopt:

  ## In your class
  package My::App;
  use Mouse;

  with 'MouseX::SimpleConfig';
  with 'MouseX::Getopt';

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
is based on the abstract role L<MouseX::ConfigFromFile>, and uses
L<Config::Any> to load your configfile.  L<Config::Any> will in
turn support any of a variety of different config formats, detected
by the file extension.  See L<Config::Any> for more details about
supported formats.

Like all L<MouseX::ConfigFromFile> -derived configfile loaders, this
module is automatically supported by the L<MouseX::Getopt> role as
well, which allows specifying C<-configfile> on the commandline.

=head1 ATTRIBUTES

=head2 configfile

Provided by the base role L<MouseX::ConfigFromFile>.  You can
provide a default configfile pathname like so:

  has '+configfile' => ( default => '/etc/myapp.yaml' );

You can pass an array of filenames if you want, but as usual the array
has to be wrapped in a sub ref.

  has '+configfile' => ( default => sub { [ '/etc/myapp.yaml', '/etc/myapp_local.yml' ] } );

Config files are trivially merged at the top level, with the right-hand files taking precedence.

=head1 CLASS METHODS

=head2 new_with_config

Provided by the base role L<MouseX::ConfigFromFile>.  Acts just like
regular C<new()>, but also accepts an argument C<configfile> to specify
the configfile from which to load other attributes.  Explicit arguments
to C<new_with_config> will override anything loaded from the configfile.

=head2 get_config_from_file

Called internally by either C<new_with_config> or L<MouseX::Getopt>'s
C<new_with_options>.  Invokes L<Config::Any> to parse C<configfile>.
