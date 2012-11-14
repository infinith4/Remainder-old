use strict;
use warnings;

use Remainder;

my $app = Remainder->apply_default_middlewares(Remainder->psgi_app);
$app;

