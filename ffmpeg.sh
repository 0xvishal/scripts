#!/bin/bash

# Bash Script to Install FFMPEG in Ubuntu 16.04
# Ref: http://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# Opsional: install exiftool: apt-get install libimage-exiftool-perl
#
# Author: Vishal Gupta 
# Email: er.vishalkumargupta@gmail.com
########################################################################
# CURDIR=$(pwd)

echo "Install Pre-requisites libraries..."
sleep 3
sudo apt-get update

sudo apt-get -y install autoconf automake build-essential libass-dev \
     libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texinfo wget zlib1g-dev

# mkdir $CURDIR/ffmpeg_sources
mkdir ~/ffmpeg_sources


## yasm-1.3.0
clear
echo "Install Yasm library..."
sleep 3
# sudo apt-get install yasm
cd ~/ffmpeg_sources
if [ ! -d yasm-1.3.0 ]; then
	wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
	tar xzvf yasm-1.3.0.tar.gz
fi
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

## nasm
clear
echo "Install NASM assembler library"
sleep 3
cd ~/ffmpeg_sources
if [ ! -d nasm-2.13.01 ]; then
	wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2
	tar xjvf nasm-2.13.01.tar.bz2
fi
cd nasm-2.13.01
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
PATH="$HOME/bin:$PATH" make
make install


## libx264
clear
echo "Install libx264 -  H.264 video encoder library..."
sleep 3
# sudo apt-get install libx264-dev
cd ~/ffmpeg_sources
if [ ! -d x264-snapshot* ]; then 
	wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
	tar xjvf last_x264.tar.bz2
fi
cd x264-snapshot*
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl
PATH="$HOME/bin:$PATH" make
make install

## libx265
clear
echo "Install H.265/HEVC video encoder library..."
sleep 3
# sudo apt-get install libx265-dev
sudo apt-get install cmake mercurial
cd ~/ffmpeg_sources
if [ ! -d x265 ]; then 
	hg clone https://bitbucket.org/multicoreware/x265
fi
cd ~/ffmpeg_sources/x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install


## libfdk-aac 
clear
echo "Install libfdk-aac - AAC audio encoder library..."
sleep 3
# sudo apt-get install libfdk-aac-dev
cd ~/ffmpeg_sources
#wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
if [ ! -d mstorsjo-fdk-aac* ]; then 
	wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
	tar xzvf fdk-aac.tar.gz
fi
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

## libmp3lame
clear
echo "Install libmp3lame - MP3 audio encoder library..."
sleep 3
# sudo apt-get install libmp3lame-dev
cd ~/ffmpeg_sources
if [ ! -d lame-3.995.5 ]; then 
	wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
	tar xzvf lame-3.99.5.tar.gz
fi
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
make
make install


## libopus
clear
echo "Install libopus - Opus audio decoder and encoder library..."
sleep 3
# sudo apt-get install libopus-dev
cd ~/ffmpeg_sources
if [ ! -d opus-1.1.5 ]; then
	wget https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
	tar xzvf opus-1.1.5.tar.gz
fi
cd opus-1.1.5
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

## libvpx
clear
echo "Install libvpx-dev library..."
sleep 3
# sudo apt-get install libvpx-dev
sudo apt-get install git
echo "Install libvpx - VP8/VP9 video encoder and decoder library..."
sleep 3
cd ~/ffmpeg_sources
if [ ! -d libvpx ]; then
	git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
fi
cd libvpx
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth
PATH="$HOME/bin:$PATH" make
make install

## ffmpeg
clear
echo "Install FFMPeg..."
sleep 3
cd ~/ffmpeg_sources
if [ ! -d ffmpeg ]; then
	wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
	tar xjvf ffmpeg-snapshot.tar.bz2
fi
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
--prefix="$HOME/ffmpeg_build" --pkg-config-flags="--static" \
--extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
--bindir="$HOME/bin" --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype \
--enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx \
--enable-nonfree
PATH="$HOME/bin:$PATH" make
make install
hash -r

## Updating ffmpeg
# rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffplay,ffserver,x264,x265}

# rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffplay,ffserver,x264,x265,nasm}
# sudo apt-get autoremove autoconf automake build-essential cmake libass-dev libfreetype6-dev \
#     libmp3lame-dev libopus-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev \
#    libvorbis-dev libvpx-dev libx264-dev libxcb1-dev libxcb-shm0-dev ibxcb-xfixes0-dev mercurial texinfo zlib1g-dev
# sed -i '/ffmpeg_build/c\' ~/.manpath
# hash -r

