use Test::Most;

use Clonable::Util qw(arrayref clonable coderef hashref simple special sp);

{
  package T;
  use Moo;
  with 'Clonable';
}

eq_or_diff(arrayref([1,2,3]),1);
eq_or_diff(arrayref(T->new ),undef);
eq_or_diff(arrayref(sub {} ),undef);
eq_or_diff(arrayref({}     ),undef);
eq_or_diff(arrayref(1234567),undef);
eq_or_diff(arrayref("abcde"),undef);
# eq_or_diff(arrayref(sp('a')),undef);

eq_or_diff(clonable([1,2,3]),undef);
eq_or_diff(clonable(T->new ),1);
eq_or_diff(clonable(sub {} ),undef);
eq_or_diff(clonable({}     ),undef);
eq_or_diff(clonable(1234567),undef);
eq_or_diff(clonable("abcde"),undef);
# eq_or_diff(clonable(sp('a')),undef);

eq_or_diff(coderef([1,2,3]),undef);
eq_or_diff(coderef(T->new ),undef);
eq_or_diff(coderef(sub {} ),1);
eq_or_diff(coderef({}     ),undef);
eq_or_diff(coderef(1234567),undef);
eq_or_diff(coderef("abcde"),undef);
# eq_or_diff(coderef(sp('a')),undef);

eq_or_diff(hashref([1,2,3]),undef);
eq_or_diff(hashref(T->new ),undef);
eq_or_diff(hashref(sub {} ),undef);
eq_or_diff(hashref({}     ),1);
eq_or_diff(hashref(1234567),undef);
eq_or_diff(hashref("abcde"),undef);
# eq_or_diff(hashref(sp('a')),undef);

eq_or_diff(simple([1,2,3]),undef);
eq_or_diff(simple(T->new ),undef);
eq_or_diff(simple(sub {} ),undef);
eq_or_diff(simple({}     ),undef);
eq_or_diff(simple(1234567),1);
eq_or_diff(simple("abcde"),1);
# eq_or_diff(simple(sp('a')),undef);

eq_or_diff(special([1,2,3]),undef);
eq_or_diff(special(T->new ),undef);
eq_or_diff(special(sub {} ),undef);
eq_or_diff(special({}     ),undef);
eq_or_diff(special(1234567),undef);
eq_or_diff(special("abcde"),undef);
# eq_or_diff(special(sp('a')),1);

done_testing;
