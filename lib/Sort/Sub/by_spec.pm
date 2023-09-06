package Sort::Sub::by_spec;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    return {
        v => 1,
        summary => 'Sort by spec',
        description => <<'MARKDOWN',

This sorter allows you to sort "by spec". Sorting by spec is an advanced form of
sorting by example. In addition to specifying strings of examples, you can also
specify regexes or Perl sorter codes. Thus the spec is an arrayref of
strings|regexes|coderefs. For more details, see the sorting backend module
<pm:Sort::BySpec>.

On the command-line, you can specify a coderef in the form of:

    sub { ... }

which returns the spec. For example:

    sub { [qr/[13579]\z/, 4, 2, 42, sub {$_[1] <=> $_[0]}] }

MARKDOWN
        args => {
            spec => {
                summary => "Either an array of str|re|code's or a code that returns the former",
                schema => ['any' => {of=>[
                    ['array*', of=>'str_or_re_or_code*'],
                    ['code*'],
                ],}],
                req => 1,
                pos => 0,
            },
        },
    };
}

sub gen_sorter {
    require Sort::BySpec;

    my ($is_reverse, $is_ci, $args) = @_;

    die "Sorting case-insensitively not supported yet" if $is_ci;

    my $spec = ref $args->{spec} eq 'CODE' ?
        $args->{spec}->() : $args->{spec};

    Sort::BySpec::cmp_by_spec(spec=>$spec, reverse=>$is_reverse);
}

1;
# ABSTRACT:

=for Pod::Coverage ^(gen_sorter|meta)$

=head1 DESCRIPTION

=head1 prepend:SEE ALSO

L<Sort::BySpec>
