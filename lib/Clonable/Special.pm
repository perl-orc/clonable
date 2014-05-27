package Clonable::Special;

# ABSTRACT: Objects that represent custom cloning behaviour

use Moo;

has name => (
  is => 'ro',
  required => 1,
  isa => sub {die("name must be a string") if ref(shift)},
);

has callback => (
  is => 'ro',
  required => 1,
  isa => sub {die("callback must be a coderef") unless ref(shift) eq 'CODE';},
);

sub invoke {
  my ($self, $obj) = @_;
  $self->callback->($self->name, $obj);
}

1
__END__

=head1 SYNOPSIS

    use Clonable::Special
    Clonable::Special->new(
      name => 'foo',
      callback => sub {
        die (join ",", @_);
      }
    )->invoke('bar');
    # Dies "foo,bar"

=head1 WELL THAT SEEMS KIND OF POINTLESS

It would be, if it weren't in fact a sentinel value for "this isn't a simple case".

If you require custom behaviour during the cloning process, you need this.

=head1 USEFUL USE CASES

I should write this at some point.

=head1 METHODS

=head2 new(%kwargs) => Special

Constructs the object, takes two keyword arguments, both mandatory:
C<name> the name of the attribute that you're applying custom behaviour to
C<callback> coderef that will be invoked upon Special invocation.

=head2 invoke($obj: Blessed) => Any

Invokes C<$self->callback> with two arguments: C<$self->name> and C<$obj>. Returns the result.
