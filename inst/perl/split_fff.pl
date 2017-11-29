#!/usr/bin/perl
undef $/;
$_ = <>;
$n = 0;
$pat="\x46\x46\x46\x00";
my $directory = "temp";
 unless(-e $directory or mkdir $directory) {
        die "Unable to create $directory\n";
    }
# FLIR camera E40         
# Flir Tools (comment out)
#$pat = "\x46\x46\x46\x00";
for $content (split(/(?=$pat)/)) {
        open(OUT, ">temp/frame" . sprintf("%05d",++$n) . ".fff");
        binmode OUT;
        print OUT $content;
        close(OUT);
}