package Clonable;

# ABSTRACT: Simple cloning for Moo

use Clonable::Util qw(clone_a);

use Moo::Role;

has _clonable_attrs => (
  is => 'ro',
  lazy => 1,
  default => sub {+[]}
);

sub clone {
  my ($self) = @_;
  return clone_a($self);
}

1
__END__

=head1 SYNOPSIS

=head1 METHODS

=head2 clone() => Blessed

Clones the object we're attached to, deeply
