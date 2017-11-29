#!/usr/bin/perl
undef $/;
$_ = <>;
$n = 0;
$pat = "\xff\xd8\xff\xf7";
my $directory = "temp";
 unless(-e $directory or mkdir $directory) {
        die "Unable to create $directory\n";
    }
# Flir Tools (comment out)
#$pat = "\xff\xd8\xff\xf7";
for $content (split(/(?=$pat)/)) {
        open(OUT, ">temp/frame" . sprintf("%05d",++$n) . ".jpegls");
        binmode OUT;
        print OUT $content;
        close(OUT);
}
