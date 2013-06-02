use strict;
use warnings;

use Hack4LA;

my $app = Hack4LA->apply_default_middlewares(Hack4LA->psgi_app);
$app;

