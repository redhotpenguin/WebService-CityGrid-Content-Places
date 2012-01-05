package WebService::CityGrid::Content::Places;

our $VERSION = 0.01;

use Any::Moose;
use LWP::UserAgent;
use XML::LibXML;

has 'what'      => ( is => 'ro', isa => 'Str', required => 1 );
has 'where'     => ( is => 'ro', isa => 'Str', required => 1 );
has 'publisher' => ( is => 'ro', isa => 'Str', required => 1 );
has 'rpp'       => ( is => 'ro', isa => 'Str', required => 0 );

use constant DEBUG => $ENV{CG_DEBUG} || 0;

our $Endpoint = "http://api.citygridmedia.com/content/places/v2/search/where";
our $Ua = LWP::UserAgent->new( agent => join( '_', __PACKAGE__, $VERSION ) );
our $Parser = XML::LibXML->new;

=head1 METHODS

=over 4

=item query

  $res = $Cg->query({
      where => '90210',
      what  => 'pizza%20and%20burgers', });

Queries the web service.  Dies if the http request fails, so eval it!

=cut

sub query {
    my ( $self, $args ) = @_;

    my $url = "$Endpoint?" . 'publisher=' . $self->publisher . '&';

    foreach my $attr (qw( what where )) {

        $url .= join( '=', $attr, $self->$attr ) . '&';
    }
    $url = substr( $url, 0, length($url) - 1 );

    warn("cg query $url") if DEBUG;

    $Ua->timeout(5);
    my $res = $Ua->get($url);

    die "query for $url failed!" unless $res->is_success;

    my $dom = $Parser->load_xml( string => $res->decoded_content );
    my @places = $dom->documentElement->getElementsByTagName('location');

    my @results;
    foreach my $place (@places) {

        $DB::single = 1;
        warn( "raw place: " . $place->toString ) if DEBUG;

        next if $place->toString eq '<places/>';

        my %new_args;
        foreach
          my $attr (qw( name image tagline impression_id profile website
			user_review_count ))
        {

            my $val = $place->getElementsByTagName($attr);
            if ($val) {
                my $firstchild = $val->[0]->firstChild;
                $new_args{$attr} = ($firstchild) ? $firstchild->data : '';
            }
        }

        $new_args{id} = $place->getAttribute('id');
        $DB::single = 1;
        my $result =
          WebService::CityGrid::Content::Places::Place->new( \%new_args );

        push @results, $result;
    }

    return unless @results;

    return \@results;
}

__PACKAGE__->meta->make_immutable;

package WebService::CityGrid::Content::Places::Place;

use Any::Moose;

has 'id'            => ( is => 'ro', isa => 'Int',  required => 1 );
has 'impression_id' => ( is => 'ro', isa => 'Str',  required => 1 );
has 'name'          => ( is => 'ro', isa => 'Str',  required => 1 );
has 'image'         => ( is => 'ro', isa => 'Str',  required => 1 );
has 'tagline'       => ( is => 'ro', isa => 'Str',  required => 0 );
has 'profile'       => ( is => 'ro', isa => 'Str',  required => 1 );
has 'website'       => ( is => 'ro', isa => 'Str',  required => 1 );
has 'user_review_count' => ( is => 'ro', isa => 'Int', required => 0 );
has 'top_hit'       => ( is => 'rw', isa => 'Bool', required => 0 );

=cut


<results total_hits="2" rpp="20" page="1" last_hit="2" first_hit="1">
<uri>
http://api.citygridmedia.com/search/places/v2/search/where?has_offers=false&format=xml&page=1&rpp=20&histograms=false&what=beer&where=94109&publisher=test&region_type=circle
</uri>
<did_you_mean xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<regions>
<region type="postal_code">
<name>94109</name>
<latitude>37.793858</latitude>
<longitude>-122.421669</longitude>
<default_radius>1.0500</default_radius>
</region>
</regions>
<histograms/>
<locations>
<location id="37735604">
<featured>true</featured>
<name>San Francisco Hooters</name>
<address>
<street>353 Jefferson St.</street>
<city>San Francisco</city>
<state>CA</state>
<postal_code>94133</postal_code>
</address>
<neighborhood>
Northeast, Fisherman's Wharf, Fisherman's Wharf (North Waterfront)
</neighborhood>
<latitude>37.8078</latitude>
<longitude>-122.4184</longitude>
<distance xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<image>
http://images.citysearch.net/assets/imgdb/merchant/2011/7/8/0/IWSmlotF172.jpeg
</image>
<phone_number>4155019209</phone_number>
<fax_number xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<rating>6.0</rating>
<tagline xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<profile>
http://sanfrancisco.citysearch.com/profile/37735604/san_francisco_ca/san_francisco_hooters.html
</profile>
<website>
http://sanfrancisco.citysearch.com/profile/external/37735604/san_francisco_ca/san_francisco_hooters.html
</website>
<has_video>false</has_video>
<has_offers>false</has_offers>
<offers xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<user_review_count>6</user_review_count>
<sample_categories>
Chicken Wings, Bars & Pubs, Restaurants, Sports Bars, Carry Out
</sample_categories>
<impression_id>000b000000b084d71537ad4319b8c2993f8c5bbfb3</impression_id>
<expansion/>
<tags>
<tag id="13700" primary="false">Chicken Wings</tag>
<tag id="1686" primary="false">Bars & Pubs</tag>
<tag id="1722" primary="false">Restaurants</tag>
<tag id="1701" primary="false">Sports Bars</tag>
<tag id="11247" primary="false">Carry Out</tag>
<tag id="11190" primary="false">Traditional American</tag>
<tag id="11228" primary="false">Seafood</tag>
<tag id="11361" primary="false">MasterCard</tag>
<tag id="11349" primary="false">Discover</tag>
<tag id="11178" primary="false">Beer</tag>
<tag id="11382" primary="false">Visa</tag>
<tag id="11085" primary="false">Draft Beer</tag>
<tag id="11333" primary="false">American Express</tag>
<tag id="11270" primary="false">Hamburgers</tag>
</tags>
<public_id>san-francisco-hooters-san-francisco</public_id>
</location>
<location id="45502942">
<featured>false</featured>
<name>City Beer Store</name>
<address>
<street>1168 Folsom St</street>
<city>San Francisco</city>
<state>CA</state>
<postal_code>94103</postal_code>
</address>
<neighborhood>SoMa, SoMa (South of Market), Central East</neighborhood>
<latitude>37.7758</latitude>
<longitude>-122.4094</longitude>
<distance xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<image xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<phone_number>4155031033</phone_number>
<fax_number xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<rating>8.0</rating>
<tagline xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<profile>
http://sanfrancisco.citysearch.com/profile/45502942/san_francisco_ca/city_beer_store.html
</profile>
<website xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<has_video>false</has_video>
<has_offers>false</has_offers>
<offers xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
<user_review_count>3</user_review_count>
<sample_categories>Liquor Stores, MasterCard, Discover, Beer, Visa</sample_categories>
<impression_id>000b000000d2840d0b30bb42afadf94593952f77af</impression_id>
<expansion/>
<tags>
<tag id="1720" primary="false">Liquor Stores</tag>
<tag id="11361" primary="false">MasterCard</tag>
<tag id="11349" primary="false">Discover</tag>
<tag id="11178" primary="false">Beer</tag>
<tag id="11382" primary="false">Visa</tag>
</tags>
<public_id>city-beer-store-san-francisco</public_id>
</location>
</locations>
</results>

=cut

1;
__END__


=head1 NAME

WebService-CityGrid-Content-Places - CityGrid content places interface

=head1 SYNOPSIS

  use WebService-CityGrid-Content-Places;

=head1 DESCRIPTION

Interface to CityGrid Places API

=head2 EXPORT

None by default.



=head1 SEE ALSO

=head1 AUTHOR

Fred Moyer, E<lt>fred@slwifi.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 Silver Lining Networks Inc.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
