Command Line Instructions for Converting FLIR Video and JPG files for import to ImageJ
================

### System Requirements

Exiftool: <https://www.sno.phy.queensu.ca/~phil/exiftool/>

Imagemagick: <https://www.imagemagick.org/script/index.php>

Perl: <https://www.perl.org/get.html>

### Download and extract sample files to SampleFLIR folder on desktop:

<https://github.com/gtatters/Thermimage/blob/master/READMEimages/SampleFLIR.zip>

``` bash
cd ~/Desktop/SampleFLIR
ls
```

    ## SampleFLIR.csq
    ## SampleFLIR.jpg
    ## SampleFLIR.seq

### Download and extract perl scripts to perl folder on desktop:

<https://github.com/gtatters/Thermimage/blob/master/READMEimages/perl.zip>

``` bash
cd ~/Desktop/perl
ls
```

    ## split_fff.pl
    ## split_jpegls.pl
    ## split_tiff.pl

### Workflow to convert csq (1024x768) to avi file

1.  Break video into .fff files into temp/ subfolder and extract times from each frame.
2.  Put raw thermal data from fff into one thermalvid.raw file in temp folder.
3.  Break thermalvid.raw video from .CSQ file into .jpegls files into temp folder.
4.  Convert all jpegls files into avi file.
    -----Use -codec png for compatibility, -codec jpegls for greater compression. -----Use -pix\_fmt gray16be for big endian export format, -pix\_fmt gray16le for little endian format. -----Use -f image2 -codec png to export a series of PNG files instead of an avi.
5.  Import avi into ImageJ using File-&gt;Import-&gt;Movie(ffmpeg) import routine. -----Import png files into ImageJ using File-&gt;Import-&gt;Image Sequence

``` bash
cd ~/Desktop
perl -f ~/Desktop/perl/split_fff.pl ~/Desktop/SampleFLIR/SampleFLIR.csq
ls temp
rm temp/frame00008.fff # remove 8th frame - due to file corruption
echo

exiftool -DateTimeOriginal temp/*.fff 
exiftool -b -RawThermalImage temp/*.fff > temp/thermalvid.raw
ls temp/*.raw
echo

perl -f ~/Desktop/perl/split_jpegls.pl temp/thermalvid.raw
ls temp/*.jpegls
echo

ffmpeg -f image2 -vcodec jpegls -r 30 -s 1024x768 -i ~/Desktop/temp/frame%05d.jpegls -pix_fmt gray16be -vcodec jpegls -s 1024x768 CSQconverted.avi -y
echo

ffmpeg -f image2 -vcodec jpegls -r 30 -s 1024x768 -i ~/Desktop/temp/frame%05d.jpegls -f image2 -pix_fmt gray16be -vcodec png -s 1024x768 frame%05d.png -y

ls *.avi
ls *.png
rm -r temp
```

    ## frame00001.fff
    ## frame00002.fff
    ## frame00003.fff
    ## frame00004.fff
    ## frame00005.fff
    ## frame00006.fff
    ## frame00007.fff
    ## frame00008.fff
    ## 
    ## ======== temp/frame00001.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.583-07:00
    ## ======== temp/frame00002.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.617-07:00
    ## ======== temp/frame00003.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.650-07:00
    ## ======== temp/frame00004.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.683-07:00
    ## ======== temp/frame00005.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.717-07:00
    ## ======== temp/frame00006.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.750-07:00
    ## ======== temp/frame00007.fff
    ## Date/Time Original              : 2017:05:19 12:45:33.783-07:00
    ##     7 image files read
    ## temp/thermalvid.raw
    ## 
    ## temp/frame00001.jpegls
    ## temp/frame00002.jpegls
    ## temp/frame00003.jpegls
    ## temp/frame00004.jpegls
    ## temp/frame00005.jpegls
    ## temp/frame00006.jpegls
    ## temp/frame00007.jpegls
    ## 
    ## ffmpeg version 3.4 Copyright (c) 2000-2017 the FFmpeg developers
    ##   built with Apple LLVM version 9.0.0 (clang-900.0.38)
    ##   configuration: --prefix=/usr/local/Cellar/ffmpeg/3.4 --enable-shared --enable-pthreads --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-gpl --enable-libmp3lame --enable-libvpx --enable-libx264 --enable-libxvid --enable-opencl --enable-videotoolbox --disable-lzma
    ##   libavutil      55. 78.100 / 55. 78.100
    ##   libavcodec     57.107.100 / 57.107.100
    ##   libavformat    57. 83.100 / 57. 83.100
    ##   libavdevice    57. 10.100 / 57. 10.100
    ##   libavfilter     6.107.100 /  6.107.100
    ##   libavresample   3.  7.  0 /  3.  7.  0
    ##   libswscale      4.  8.100 /  4.  8.100
    ##   libswresample   2.  9.100 /  2.  9.100
    ##   libpostproc    54.  7.100 / 54.  7.100
    ## Input #0, image2, from '/Users/GlennTattersall/Desktop/temp/frame%05d.jpegls':
    ##   Duration: 00:00:00.23, start: 0.000000, bitrate: N/A
    ##     Stream #0:0: Video: jpegls, gray16le(bt470bg/unknown/unknown), 1024x768, lossless, 30 fps, 30 tbr, 30 tbn, 30 tbc
    ## Stream mapping:
    ##   Stream #0:0 -> #0:0 (jpegls (native) -> jpegls (native))
    ## Press [q] to stop, [?] for help
    ## Incompatible pixel format 'gray16be' for codec 'jpegls', auto-selecting format 'gray16le'
    ## Output #0, avi, to 'CSQconverted.avi':
    ##   Metadata:
    ##     ISFT            : Lavf57.83.100
    ##     Stream #0:0: Video: jpegls (MJLS / 0x534C4A4D), gray16le, 1024x768, q=2-31, 200 kb/s, 30 fps, 30 tbn, 30 tbc
    ##     Metadata:
    ##       encoder         : Lavc57.107.100 jpegls
    ## frame=    7 fps=0.0 q=-0.0 Lsize=    3656kB time=00:00:00.23 bitrate=128339.8kbits/s speed=1.08x    
    ## video:3650kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.156768%
    ## 
    ## ffmpeg version 3.4 Copyright (c) 2000-2017 the FFmpeg developers
    ##   built with Apple LLVM version 9.0.0 (clang-900.0.38)
    ##   configuration: --prefix=/usr/local/Cellar/ffmpeg/3.4 --enable-shared --enable-pthreads --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-gpl --enable-libmp3lame --enable-libvpx --enable-libx264 --enable-libxvid --enable-opencl --enable-videotoolbox --disable-lzma
    ##   libavutil      55. 78.100 / 55. 78.100
    ##   libavcodec     57.107.100 / 57.107.100
    ##   libavformat    57. 83.100 / 57. 83.100
    ##   libavdevice    57. 10.100 / 57. 10.100
    ##   libavfilter     6.107.100 /  6.107.100
    ##   libavresample   3.  7.  0 /  3.  7.  0
    ##   libswscale      4.  8.100 /  4.  8.100
    ##   libswresample   2.  9.100 /  2.  9.100
    ##   libpostproc    54.  7.100 / 54.  7.100
    ## Input #0, image2, from '/Users/GlennTattersall/Desktop/temp/frame%05d.jpegls':
    ##   Duration: 00:00:00.23, start: 0.000000, bitrate: N/A
    ##     Stream #0:0: Video: jpegls, gray16le(bt470bg/unknown/unknown), 1024x768, lossless, 30 fps, 30 tbr, 30 tbn, 30 tbc
    ## Stream mapping:
    ##   Stream #0:0 -> #0:0 (jpegls (native) -> png (native))
    ## Press [q] to stop, [?] for help
    ## Output #0, image2, to 'frame%05d.png':
    ##   Metadata:
    ##     encoder         : Lavf57.83.100
    ##     Stream #0:0: Video: png, gray16be, 1024x768, q=2-31, 200 kb/s, 30 fps, 30 tbn, 30 tbc
    ##     Metadata:
    ##       encoder         : Lavc57.107.100 png
    ## frame=    7 fps=0.0 q=-0.0 Lsize=N/A time=00:00:00.23 bitrate=N/A speed=0.69x    
    ## video:4758kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: unknown
    ## CSQconverted.avi
    ## SEQconvertedjpegls.avi
    ## SEQconvertedpng.avi
    ## JPGconverted.png
    ## frame00001.png
    ## frame00002.png
    ## frame00003.png
    ## frame00004.png
    ## frame00005.png
    ## frame00006.png
    ## frame00007.png

Which produces the following output:

<https://github.com/gtatters/Thermimage/blob/master/READMEimages/CSQconverted.avi?raw=true>

The above avi should open up in VLC player, but may or may not play properly. In ImageJ, with the ffmpeg plugin installed, the jpegls compression should work.

![Sample PNG](https://github.com/gtatters/Thermimage/blob/master/READMEimages/frame00001.png?raw=true) The above PNG file is a sample image of the 16 bit grayscale image. Although it looks washed out, it can be imported into ImageJ and the Brightness/Contrast changed for optimal viewing.

### Workflow to convert seq (640x480) to avi file

1.  Break video into .fff files into temp/ subfolder and extract times from each frame.
2.  Put raw thermal data from fff into one thermalvid.raw file in temp folder.
3.  Break thermalvid.raw video from .CSQ file into .tiff files into temp folder.
4.  Convert all tiff files into avi file.
5.  Convert all jpegls files into avi file.
    ----- Use -codec png for compatibility, -codec jpegls for greater compression. ------Use -pix\_fmt gray16be for big endian export format, -pix\_fmt gray16le for little endian format.
6.  Import avi into ImageJ using File-&gt;Import-&gt;Movie(ffmpeg) import routine.

``` bash
cd ~/Desktop
perl -f ~/Desktop/perl/split_fff.pl ~/Desktop/SampleFLIR/SampleFLIR.seq
ls temp
echo

#exiftool -DateTimeOriginal temp/*.fff 
exiftool -b -RawThermalImage temp/*.fff > temp/thermalvid.raw
ls temp/*.raw
echo

perl -f ~/Desktop/perl/split_tiff.pl < temp/thermalvid.raw
ls temp/*.tiff
echo


ffmpeg -f image2 -vcodec tiff -r 30 -s 640x480 -i ~/Desktop/temp/frame%05d.tiff -pix_fmt gray16be -vcodec jpegls -s 640x480 SEQconvertedjpegls.avi -y
ffmpeg -f image2 -vcodec tiff -r 30 -s 640x480 -i ~/Desktop/temp/frame%05d.tiff -pix_fmt gray16be -vcodec png -s 640x480 SEQconvertedpng.avi -y
echo

ls *.avi
rm -r temp
```

    ## frame00001.fff
    ## frame00002.fff
    ## frame00003.fff
    ## frame00004.fff
    ## frame00005.fff
    ## frame00006.fff
    ## frame00007.fff
    ## frame00008.fff
    ## frame00009.fff
    ## frame00010.fff
    ## frame00011.fff
    ## frame00012.fff
    ## frame00013.fff
    ## frame00014.fff
    ## frame00015.fff
    ## frame00016.fff
    ## frame00017.fff
    ## frame00018.fff
    ## frame00019.fff
    ## frame00020.fff
    ## frame00021.fff
    ## frame00022.fff
    ## frame00023.fff
    ## frame00024.fff
    ## frame00025.fff
    ## frame00026.fff
    ## frame00027.fff
    ## frame00028.fff
    ## 
    ## temp/thermalvid.raw
    ## 
    ## temp/frame00001.tiff
    ## temp/frame00002.tiff
    ## temp/frame00003.tiff
    ## temp/frame00004.tiff
    ## temp/frame00005.tiff
    ## temp/frame00006.tiff
    ## temp/frame00007.tiff
    ## temp/frame00008.tiff
    ## temp/frame00009.tiff
    ## temp/frame00010.tiff
    ## temp/frame00011.tiff
    ## temp/frame00012.tiff
    ## temp/frame00013.tiff
    ## temp/frame00014.tiff
    ## temp/frame00015.tiff
    ## temp/frame00016.tiff
    ## temp/frame00017.tiff
    ## temp/frame00018.tiff
    ## temp/frame00019.tiff
    ## temp/frame00020.tiff
    ## temp/frame00021.tiff
    ## temp/frame00022.tiff
    ## temp/frame00023.tiff
    ## temp/frame00024.tiff
    ## temp/frame00025.tiff
    ## temp/frame00026.tiff
    ## temp/frame00027.tiff
    ## temp/frame00028.tiff
    ## 
    ## ffmpeg version 3.4 Copyright (c) 2000-2017 the FFmpeg developers
    ##   built with Apple LLVM version 9.0.0 (clang-900.0.38)
    ##   configuration: --prefix=/usr/local/Cellar/ffmpeg/3.4 --enable-shared --enable-pthreads --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-gpl --enable-libmp3lame --enable-libvpx --enable-libx264 --enable-libxvid --enable-opencl --enable-videotoolbox --disable-lzma
    ##   libavutil      55. 78.100 / 55. 78.100
    ##   libavcodec     57.107.100 / 57.107.100
    ##   libavformat    57. 83.100 / 57. 83.100
    ##   libavdevice    57. 10.100 / 57. 10.100
    ##   libavfilter     6.107.100 /  6.107.100
    ##   libavresample   3.  7.  0 /  3.  7.  0
    ##   libswscale      4.  8.100 /  4.  8.100
    ##   libswresample   2.  9.100 /  2.  9.100
    ##   libpostproc    54.  7.100 / 54.  7.100
    ## Input #0, image2, from '/Users/GlennTattersall/Desktop/temp/frame%05d.tiff':
    ##   Duration: 00:00:00.93, start: 0.000000, bitrate: N/A
    ##     Stream #0:0: Video: tiff, gray16le, 640x480 [SAR 1:1 DAR 4:3], 30 fps, 30 tbr, 30 tbn, 30 tbc
    ## Stream mapping:
    ##   Stream #0:0 -> #0:0 (tiff (native) -> jpegls (native))
    ## Press [q] to stop, [?] for help
    ## Incompatible pixel format 'gray16be' for codec 'jpegls', auto-selecting format 'gray16le'
    ## Output #0, avi, to 'SEQconvertedjpegls.avi':
    ##   Metadata:
    ##     ISFT            : Lavf57.83.100
    ##     Stream #0:0: Video: jpegls (MJLS / 0x534C4A4D), gray16le, 640x480 [SAR 1:1 DAR 4:3], q=2-31, 200 kb/s, 30 fps, 30 tbn, 30 tbc
    ##     Metadata:
    ##       encoder         : Lavc57.107.100 jpegls
    ## frame=   28 fps=0.0 q=-0.0 Lsize=    5763kB time=00:00:00.93 bitrate=50583.9kbits/s speed=10.4x    
    ## video:5757kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.109466%
    ## ffmpeg version 3.4 Copyright (c) 2000-2017 the FFmpeg developers
    ##   built with Apple LLVM version 9.0.0 (clang-900.0.38)
    ##   configuration: --prefix=/usr/local/Cellar/ffmpeg/3.4 --enable-shared --enable-pthreads --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-gpl --enable-libmp3lame --enable-libvpx --enable-libx264 --enable-libxvid --enable-opencl --enable-videotoolbox --disable-lzma
    ##   libavutil      55. 78.100 / 55. 78.100
    ##   libavcodec     57.107.100 / 57.107.100
    ##   libavformat    57. 83.100 / 57. 83.100
    ##   libavdevice    57. 10.100 / 57. 10.100
    ##   libavfilter     6.107.100 /  6.107.100
    ##   libavresample   3.  7.  0 /  3.  7.  0
    ##   libswscale      4.  8.100 /  4.  8.100
    ##   libswresample   2.  9.100 /  2.  9.100
    ##   libpostproc    54.  7.100 / 54.  7.100
    ## Input #0, image2, from '/Users/GlennTattersall/Desktop/temp/frame%05d.tiff':
    ##   Duration: 00:00:00.93, start: 0.000000, bitrate: N/A
    ##     Stream #0:0: Video: tiff, gray16le, 640x480 [SAR 1:1 DAR 4:3], 30 fps, 30 tbr, 30 tbn, 30 tbc
    ## Stream mapping:
    ##   Stream #0:0 -> #0:0 (tiff (native) -> png (native))
    ## Press [q] to stop, [?] for help
    ## Output #0, avi, to 'SEQconvertedpng.avi':
    ##   Metadata:
    ##     ISFT            : Lavf57.83.100
    ##     Stream #0:0: Video: png (MPNG / 0x474E504D), gray16be, 640x480 [SAR 1:1 DAR 4:3], q=2-31, 200 kb/s, 30 fps, 30 tbn, 30 tbc
    ##     Metadata:
    ##       encoder         : Lavc57.107.100 png
    ## frame=   28 fps=0.0 q=-0.0 Lsize=   10032kB time=00:00:00.93 bitrate=88049.1kbits/s speed=4.07x    
    ## video:10025kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.062800%
    ## 
    ## CSQconverted.avi
    ## SEQconvertedjpegls.avi
    ## SEQconvertedpng.avi

Which produces the following output:

<https://github.com/gtatters/Thermimage/blob/master/READMEimages/SEQconvertedjpegls.avi?raw=true> <https://github.com/gtatters/Thermimage/blob/master/READMEimages/SEQconvertedpng.avi?raw=true>

Note: the above avi should open up in VLC player, but may or may not play properly. In ImageJ, with the ffmpeg plugin installed, the jpegls compression should work.

### Workflow to convert FLIR jpg (640x480) to png file

1.  Use exiftool to extract RawThermalImage from the FLIR jpg.
2.  Pass the raw thermal image data to imagemagick's convert function to convert to 16 bi grayscale with little endian
3.  Convert to PNG (PNG is lossless, compressed, and easiest). --- Save to different filetype (tiff, bmp, or jpg) as needed (not recommended for further analysis).
4.  Use exiftool to extract calibration constants from file (for use in converting raw values)

``` bash
cd ~/Desktop
exiftool ~/Desktop/SampleFLIR/SampleFLIR.jpg -b -RawThermalImage | convert - gray:- | convert -depth 16 -endian lsb -size 640x480 gray:- JPGconverted.png

exiftool ~/Desktop/SampleFLIR/SampleFLIR.jpg -*Planck*
```

    ## Planck R1                       : 21106.77
    ## Planck B                        : 1501
    ## Planck F                        : 1
    ## Planck O                        : -7340
    ## Planck R2                       : 0.012545258

![Sample PNG](https://github.com/gtatters/Thermimage/blob/master/READMEimages/JPGconverted.png?raw=true)

### Workflow to convert FLIR jpg multi-burst (with ultramax) to png file

Note: this section is a work in progress. Code below is not yet functional, but saved here for reference.

Extract the multiple raw thermal image burts and export as .hex exiftool -config config.txt -a -b -CompressedBurst -v -W "Image/%.2c.hex" IR\_2017-02-10\_0003.jpg

Extract the just the first of the multiple raw thermal image burts and export as .hex exiftool -config config.txt -b -CompressedBurst -v -W "%.2c.hex" IR\_2017-02-10\_0003.jpg

Convert these .hex files to png ffmpeg -f image2 -vcodec jpegls -i "%02d.hex" -f image2 -vcodec png burst%02d.png

ffmpeg -f image2 -vcodec jpegls -i "./Image/%02d.hex" -f image2 -vcodec png PNG/burst%02d.png

Then try using fairSIM from github - a plug-in for ImageJ that produces the superresolution image

##### Stay tuned....imageJ macros are in development

### References

1.  <https://www.sno.phy.queensu.ca/~phil/exiftool/>

2.  <https://www.imagemagick.org/script/index.php>

3.  <https://www.eevblog.com/forum/thermal-imaging/csq-file-format/>
