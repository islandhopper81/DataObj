use strict;
use warnings;

use Test::More tests => 20;
use Test::Exception;

# others to include


BEGIN { use_ok( 'DataObj' ); }

# test constructor
my $data;
lives_ok(sub{ $data = DataObj->new() }, "expect to live - new()" );

# test set_feature
{
	throws_ok(sub{ $data->set_feature() },
              "MyX::Generic::Undef::Param",
              "throws - set_feature()" );
    throws_ok(sub{ $data->set_feature("feat") },
              "MyX::Generic::Undef::Param",
              "throws - set_feature(feat)" );
    lives_ok(sub{ $data->set_feature("feat", 1) },
             "lives - set_feature(feat, 1)" );
    lives_ok(sub{ $data->set_feature("feat2", 2) },
             "lives - set_feature(feat2, 2)" );
}

# test get_feature
{
    throws_ok(sub{ $data->get_feature() },
              "MyX::Generic::Undef::Param",
              "throws - get_feature()" );
    lives_ok(sub{ $data->get_feature("blah") },
             "lives - get_feature(blah)" );
    lives_ok(sub{ $data->get_feature("feat") },
             "lives - get_feature(feat)" );
    is( $data->get_feature("feat"), 1, "get_feature(feat) == 1" );
    is( $data->get_feature("feat2"), 2, "get_feature(feat2) == 2" );
}

# test to_string
{
    my $ans = "feat: 1\nfeat2: 2\n";
    lives_ok(sub{ $data->to_string() },
             "lives - to_string()" );
    is( $data->to_string(), $ans, "to_string()" );
}

# test get_data_href
{
    my $ans = {"feat" => 1,
                "feat2" => 2};
    lives_ok(sub{ $data->get_data_href() },
             "lives - get_data_href()" );
    is_deeply( $data->get_data_href(), $ans,
              "get_data_href()" );
}

# test get_feature_names
{
    my $aref = ["feat", "feat2"];
    lives_ok(sub{ $data->get_feature_names() },
             "lives - get_feature_names()" );
    is_deeply($data->get_feature_names(), $aref,
              "get_feature_names()" );
}

# test set_data_href
{
    my $new_href = {"new3" => 3,
                    "new4" => 4};
    throws_ok(sub{ $data->set_data_href() },
              "MyX::Generic::Undef::Param",
              "throw - set_data_href()" );
    lives_ok(sub{ $data->set_data_href($new_href) },
             "lives - set_data_href(new_href)" );
    is_deeply($data->get_data_href(), $new_href,
              "get_data_href() - after set_data_href" );
}
