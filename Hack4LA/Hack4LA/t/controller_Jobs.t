use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Hack4LA';
use Hack4LA::Controller::Jobs;

ok( request('/jobs')->is_success, 'Request should succeed' );
done_testing();
