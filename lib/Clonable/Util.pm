package Clonable::Util;

# ABSTRACT: Utilities that are useful for keeping the implementation clean

use strictures;
use Carp qw(croak);
use Clonable::Special;
use Exporter;
use Safe::Isa;
use Scalar::Util 'blessed';

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(arrayref clonable coderef hashref simple special clone_simple clone_arrayref clone_hashref clone_attr clone_clonable clone_a clone sp);

sub arrayref {ref(shift) eq 'ARRAY' or undef;}
sub clonable {shift->$_does('Clonable') or undef;}
sub coderef {ref(shift) eq 'CODE' or undef};
sub hashref {ref(shift) eq 'HASH' or undef;}
sub simple {!ref(shift) or undef;}
sub special {shift->$_isa('Clonable::Special') or undef};

sub clone_simple {
  my $s = shift;
  croak("clone_simple: not simple: $s")
    unless simple($s);
  return $s;
}

sub clone_arrayref {
  my $ar = shift;
  croak("clone_arrayref: not arrayref: $ar")
    unless arrayref($ar);
  my @new = map clone_a($_), @$ar;
  return [@new];
}

sub clone_hashref {
  my $hr = shift;
  croak("clone_hashref: not hashref: $hr")
    unless hashref($hr);
  my %new = map {
    $_ => clone_a($hr->{$_})
  } (keys %$hr);
  return {%new};
}

sub clone_attr {
  my ($obj, $attr) = @_;
  croak("Undefined attr!") unless $attr;
  return ($attr => clone_a($obj->$attr))
    if simple($attr);
  return ($attr->name => $attr->invoke($attr->name, $obj))
    if special($attr);
  croak("clone_attr: don't know what to do with '$attr'");
}

sub clone_clonable {
  my $c = shift;
  croak("clone_clonable: not clonable: $c")
    unless clonable($c);
  my %new = map clone_attr($c, $_), @{$c->_clonable_attrs};
  my $pkg = blessed($c);
  return $pkg->new(%new);
}

sub clone_a {
  my ($a) = @_;
  return clone_simple($a)   if simple($a);
  return clone_arrayref($a) if arrayref($a);
  return clone_hashref($a)  if hashref($a);
  return clone_clonable($a) if clonable($a);
  croak("clone_a: don't know what to do with '$a'");
}

sub clone {
  map clone_a($_), @_;
}

sub sp {
  my ($name, $code) = @_;
  if (!$code) {
    warn 'No code given in sp($name, $code)!';
    $code = sub {};
  }
  Clonable::Special->new(name => $name, callback => $code);
}

1
__END__

=head1 PREDICATE FUNCTIONS

Yes, functions, not methods.

=head2 arrayref($thing:Any) => Undef|1

Is C<$thing> an arrayref?

=head2 clonable($thing:Any) => Undef|1

Is C<$thing> a C<Clonable>?

=head2 coderef($thing:Any) => Undef|1

Is C<$thing> a coderef?

=head2 hashref($thing:Any) => Undef|1

Is C<$thing> a hashref?

=head2 simple($thing:Any) => Undef|1

Is C<$thing> simple data (non-ref)?

=head2 special($thing:Any) => Undef|1

Is C<$thing> a C<Clonable::Special>?

=head1 CLONING FUNCTIONS

=head2 clone_simple($thing: Simple) => Simple

Clones simple C<$thing>

=head2 clone_arrayref($thing: ArrayRef) => ArrayRef

Clones arrayref C<$thing>

=head2 clone_hashref($thing: HashRef) => HashRef

Clones hashref C<$thing>

=head2 clone_attr($object:Ref, $name: Str) => (Str, Any)

Clones a attribute C<$name> on C<$object>

=head2 clone_clonable($thing: Clonable) => Clonable

Clones a C<Clonable>, C<$thing>

=head2 clone_a($thing:Any) => Any

Clones anything

=head2 clone(@things :List[Any]) => List[Any]

Clones many things

=head2 sp($name: Str, $callback: CodeRef) => Special

Manufactures a C<Special> with the given details. Useful for overriding cloning
