package HTML::FormFu::Filter::HTMLScrubber;

use strict;
use warnings;
use base 'HTML::FormFu::Filter';

use Storable qw/ dclone /;

__PACKAGE__->mk_accessors(qw/ allow /);

use HTML::Scrubber;

sub filter {
    my ( $self, $value ) = @_;

    my $allowed = $self->allow || [];

    my $scrubber = HTML::Scrubber->new( allow => $allowed );

    return $scrubber->scrub($value);
}

sub clone {
    my $self = shift;
    
    my $clone = $self->SUPER::clone(@_);
    
    $clone->allow( dclone $self->allow )
        if ref $self->allow;
    
    return $clone;
}

1;

__END__

=head1 NAME

HTML::FormFu::Filter::HTMLScrubber - HTML::Scrubber based filter

=head1 SYNOPSIS

    $form->filter( HTMLScrubber => 'foo' );

=head1 DESCRIPTION

Remove HTML markup using L<HTML::Scrubber>.

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

Based on the original source code of L<HTML::Widget::Filter::HTMLStrip>, by 
Lyo Kato, C<lyo.kato@gmail.com>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
