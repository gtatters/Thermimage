#!/usr/bin/perl

# Author: Glenn J Tattersall
# Date: 2019-04-18
# Version: 1.0

#use strict;
#use warnings;
use Getopt::Std;

our($opt_i, $opt_o, $opt_b, $opt_p, $opt_x, $opt_s, $opt_v);

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
my $patjpg = "\xff\xd8\xff\xe1"; # split out jpg headers
my $outext = "fff";
my $file = "";
my $skip = "n";

my (%opt)=();
getopts("h:i:o:b:p:x:s:v:",\%opt);
if ($opt{h}){
print qq(
    Usage: perl split -i filename -o outputfoldername -b basename -p splitpattern -x outputfileextension -s skip -v verbose
    options:
    -i input filename
    -o output folder
    -b base output name
    -p split pattern (fff, fcf, seq, csq, jpegls, tiff) 
    -x output extension (fff, jpegls, tiff)
    -s skip first part of split content
    -v verbose (y=yes, leave blank for no feedback on success) \n.);
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
$skip = $opt{s};

if ($opt{p} eq "fff"){
        $pat = $patfff;
    } elsif ($opt{p} eq "fcf"){
        $pat= $patfcf;
    } elsif ($opt{p} eq "csq"){
        $pat = $patcsq;
    } elsif ($opt{p} eq "seq"){
        $pat = $patseq;
    } elsif ($opt{p} eq "jpegls"){
        $pat = $patjpegls;
    } elsif ($opt{p} eq "tiff"){
        $pat = $pattiff;
    } elsif ($opt{p} eq "jpg"){
        $pat = $patjpg;
    }

     else {die "Error: Please specify the split pattern.\n"}

# Create output folder to store split files
unless(-e $folder or mkdir $folder) {
       die "Unable to create $directory\n";
}

# If verbose=y, then print the following update:
if ($opt{v} eq "y"){
        print "Processing $infilename\n";
    }


# Use binary mode for portability between operating systems
binmode F; 
open F, '<:raw', $infilename;
$file = do { local $/; <F> };
close F;  

# If skip=y, then we will operate the split function, but discard the first portion of the split, 
# and only save the rawdata following and including the pattern
# Only real application is for splitting fff files into fffheader + jpeglsrawdata
# This code should allow for a more generic skipping of every other split result

if ($skip eq "y"){
        my @content = split /(?=$pat)/, $file;
        my $len = ($#content + 1)/2;
        my @ind = (1); # skip the first index

        # create an index of numbers that should be odd (1,3,5,7...up to the # of images)
        for (my $i = 1; $i<$len; $i++) {
            @ind[$i] =  @$ind[($i-1)]+ 2;
        }
        # then save 
        for (my $i = 0; $i<$len; $i++) {
            $outfilename = ">$folder/$outfilebase" . sprintf("%05d",++$n) . $outext;
            open(OUT, $outfilename);
            binmode(OUT, ":raw");
            print OUT $content[$ind[$i]];
            close(OUT);
        }    
    } 

    # this is the default split functioning;
    else {
  
    # Split infilename based on $pat
    for my $content (split(/(?=$pat)/, $file)) {
        $outfilename = ">$folder/$outfilebase" . sprintf("%05d",++$n) . $outext;
        open(OUT, $outfilename);
        binmode(OUT, ":raw");
        print OUT $content;
        close(OUT);
        } 
    }

# If verbose=y, then print the following update:
if ($opt{v} eq "y"){
        print "Done splitting $infilename into $opt{x} files\n";
    }

