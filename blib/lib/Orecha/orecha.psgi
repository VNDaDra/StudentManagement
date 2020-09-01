use strict;
use warnings;

use Orecha;

my $app = Orecha->apply_default_middlewares(Orecha->psgi_app);
$app;

