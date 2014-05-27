use Test::Most;

use Clonable::Util qw(
  clone_simple clone_arrayref clone_hashref
  clone_attr clone_clonable clone_a
  clone sp
);
use Scalar::Util 'blessed';

my $a = 'a';
my $ret = clone_simple($a);
eq_or_diff($a,$ret);
$ret = 'b';
eq_or_diff($a,'a');
throws_ok {
  clone_simple({})
} qr/clone_simple: not simple: HASH/;

$a = [qw(a b c d)];
$ret = clone_arrayref($a);
eq_or_diff($a,$ret);
$ret->[0] = 'b';
eq_or_diff($a,[qw(a b c d)]);
throws_ok {
  clone_arrayref({})
} qr/clone_arrayref: not arrayref: HASH/;

$a = {qw(a b c d)};
$ret = clone_hashref($a);
eq_or_diff($a,$ret);
$ret->{'a'} = 'a';
eq_or_diff($a,{qw(a b c d)});
throws_ok {
  clone_hashref([])
} qr/clone_hashref: not hashref: ARRAY/;

{
  package T2;
  use Moo;
  use Clonable::Util 'sp';
  with 'Clonable';
  has foo => (
    is => 'ro',
    required => 1,
  );
  has bar => (
    is => 'ro',
    required => 1,
  );
  has '+_clonable_attrs' => (
    default => sub {['foo',sp('bar',sub {"bar"})]},
  );
}

my $t2 = T2->new(foo => 'foo', bar => 'foo');
eq_or_diff($t2->foo, 'foo');
eq_or_diff($t2->bar, 'foo');
eq_or_diff({clone_attr($t2,'foo')},{foo=>'foo'});
eq_or_diff({clone_attr($t2,sp('bar',sub{"bar"}))},{bar=>'bar'});

my $t3 = clone_clonable($t2);
eq_or_diff($t3->foo,'foo');
eq_or_diff($t3->bar,'bar');
$t3->{'foo'} = 'baz';
eq_or_diff($t2->foo,'foo');

eq_or_diff(clone_a('foo'),      clone_simple('foo'));
eq_or_diff(clone_a(['a',$t2]),  clone_arrayref(['a',$t2]));
eq_or_diff(clone_a({a => $t2}), clone_hashref({a => $t2}));
eq_or_diff(clone_a($t2),        clone_clonable($t2));

eq_or_diff(
  [clone('foo',['a',$t2],{a => $t2},$t2)],
  [clone_simple('foo'), clone_arrayref(['a',$t2]), clone_hashref({a => $t2}), clone_clonable($t2)]
);

my $empty = sub {};
my $sr = sp('foo', sub {
  eq_or_diff(\@_,['foo',$t2]);
  "bar";
});
eq_or_diff(blessed(sp('foo',sub{})),'Clonable::Special');
eq_or_diff(sp('foo',$empty)->name,'foo');
eq_or_diff(sp('foo',$empty)->name,'foo');
eq_or_diff(sp('foo',$empty)->callback, $empty);
eq_or_diff($sr->invoke($t2), "bar");

done_testing
