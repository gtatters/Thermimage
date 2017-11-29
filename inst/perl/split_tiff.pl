#!/usr/bin/env perl                                                         

my $big_endian = "MM\0*";
my $big_endian_regex = "MM\0\\*";
my $little_endian = "II*\0";
my $little_endian_regex = "II\\*\0";

my $tiff_magic = $little_endian;
my $tiff_magic_regex = $little_endian_regex;

my $n = 1;
my $fileprefix = "frame";
my $buffer;

{ local $/ = undef; $buffer = <stdin>; }

my @images = split /${tiff_magic_regex}/, $buffer;

for my $image (@images) {
  next if $image eq '';
  my $file = sprintf("temp/$fileprefix%05d.tiff", $n++);
  open FILE, ">", $file or die "open $file: ";
  print FILE $tiff_magic, $image or die "print $file: ";
  close FILE or die "close $file: ";
}

exit 0;