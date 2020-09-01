use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Orecha';
use Orecha::Controller::Student;

ok( request('/student')->is_success, 'Request should succeed' );
done_testing();
