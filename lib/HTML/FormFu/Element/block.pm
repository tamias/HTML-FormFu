package HTML::FormFu::Element::block;

use strict;
use warnings;
use base 'HTML::FormFu::Element';

use HTML::FormFu::ObjectUtil qw/ element constraint filter inflator deflator
    get_fields get_field get_constraints get_constraint get_filters get_filter
    get_deflators get_deflator get_inflators get_inflator
    get_errors get_error delete_errors
    get_elements get_element get_all_elements insert_after /;
use HTML::FormFu::Util qw/ _parse_args _get_elements /;
use Storable qw( dclone );
use Carp qw/croak/;

__PACKAGE__->mk_accessors(
    qw/ tag _elements element_defaults / );

__PACKAGE__->mk_inherited_accessors(
    qw/ auto_id auto_label auto_error_class auto_error_message
    auto_constraint_class /
);

*elements    = \&element;
*constraints = \&constraint;
*filters     = \&filters;
*deflators   = \&deflator;
*inflators   = \&inflator;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->_elements( [] );
    $self->element_defaults( {} );
    $self->render_class_suffix('block');
    $self->filename('block');
    $self->tag('div');

    return $self;
}

sub prepare_id {
    my ( $self, $render ) = @_;

    map { $_->prepare_id(@_) } @{ $self->_elements };

    return;
}

sub render {
    my $self = shift;

    my $render = $self->SUPER::render({
        tag       => $self->tag,
        _elements => [ map { $_->render } @{ $self->_elements } ],
        @_ ? %{$_[0]} : ()
        });

    return $render;
}

sub start {
    return shift->render->start;
}

sub end {
    return shift->render->end;
}

sub clone {
    my $self = shift;
    
    my $clone = $self->SUPER::clone(@_);
    
    $clone->{_elements} = [ map { $_->clone } @{ $self->_elements } ];
    
    $clone->{element_defaults} = dclone $self->element_defaults;
    
    return $clone;
}

1;

__END__

=head1 NAME

HTML::FormFu::Element::Block - Block element

=head1 SYNOPSIS

    my $e = $form->element( Block => 'foo' );

=head1 DESCRIPTION

Block element. Base-class for L<HTML::FormFu::Element::Fieldset>.

=head1 METHODS

=head1 SEE ALSO

Is a sub-class of, and inherits methods from L<HTML::FormFu::Element>

L<HTML::FormFu::FormFu>

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.