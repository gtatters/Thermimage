#!/usr/bin/perl

#use strict;
#use warnings;
use Getopt::Std;

our($opt_i, $opt_o, $opt_b, $opt_p, $opt_x);

my $n=0;
my $folder = "temp";
my $infilename = "filename.csq";
my $outfilebase = "frame";
my $outfilename = "";
my $pattype = "fff";
my $patfff = "\x46\x46\x46\x00"; # split a generic fff header (some seq files recorded on camera have simple headers like this)
my $patfcf = "\x46\x46\x46\x00\x43\x41\x50"; # split the fcf file type header (older video type)
my $patseq = "\x46\x46\x46\x00\x43\x41\x4D"; # split the seq file type header (based on camera controlled by computer)
my $patcsq = "\x46\x46\x46\x00\x52\x54\x50"; # split the csq file type header (compressed video format)
my $patjpegls = "\xff\xd8\xff\xf7"; # split out jpegls headers from .raw file generated from exiftool
my $pattiff = "II\\*\0"; 
my $outext = "fff";
my $file = "";

my (%opt)=();
getopts("h:i:o:b:p:x:",\%opt);
if ($opt{h}){
print qq(
    Usage: perl split -i filename -o outputfoldername -b basename -p splitpattern -x outputfileextension 
    options:
    -i input filename
    -o output folder
    -b base output name
    -p split pattern (fff, fcf, seq, csq, jpegls, tiff) 
    -x output extension (fff, jpegls, tiff)\n.);
    exit  
}

if (!defined $opt{i} & !defined $opt{o} & !defined $opt{b} & !defined $opt{p} & !defined $opt{x}){die "Error: Please specify input file, output folder, the output filename base, pattern to split, and output file extension.\n"}
if (!defined $opt{i}){die "Error: Please specify the input file. \n"}
if (!defined $opt{o}){die "Error: Please specify the output folder.\n"}
if (!defined $opt{b}){die "Error: Please specify the output filename base.\n"}
if (!defined $opt{p}){die "Error: Please specify the split pattern.\n"}
if (!defined $opt{x}){die "Error: Please specify the output file extension.\n"}

my $pattype = "$opt_p";

$folder = $opt{o};
$infilename = $opt{i};
$outfilebase = $opt{b};
$outext = ".$opt{x}";

if ($opt{p} eq "fff"){
        $pat = $patfff;
    } elsif ($opt{p} eq "fcf"){
        $pat= $patfcf;
    } elsif ($opt{p} eq "seq"){
        $pat = $patseq;
    } elsif ($opt{p} eq "jpegls"){
        $pat = $patjpegls;
    } elsif ($opt{p} eq "tiff"){
        $pat = $pattiff;
    }

     else {die "Error: Please specify the split pattern.\n"}

# Create output folder to store split files
unless(-e $folder or mkdir $folder) {
       die "Unable to create $directory\n";
}

print "Processing $infilename\n";

# Use binary mode for portability between operating systems
binmode F; 
open F, '<:raw', $infilename;
$file = do { local $/; <F> };
close F;  


# Split infilename based on $pat
for my $content (split(/(?=$pat)/, $file)) {
        $outfilename = ">$folder/$outfilebase" . sprintf("%05d",++$n) . $outext;
        open(OUT, $outfilename);
        binmode(OUT, ":raw");
        print OUT $content;
        close(OUT);
}

