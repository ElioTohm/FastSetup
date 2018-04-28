git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/
sudo apt-get install build-essential \ 
yasm \
cmake \
libtool \
libc6 \
libc6-dev \
unzip \
wget \
libnuma \
libnuma-dev \
libfdk-aac-dev \
libmp3lame-dev \
libopus-dev \
autoconf \
automake \
build-essential \
libass-dev \
libfreetype6-dev \
libsdl2-dev \
libtheora-dev \
libva-dev \
libvdpau-dev \
libvorbis-dev \
libxcb1-dev \
libxcb-shm0-dev \
libxcb-xfixes0-dev \
mercurial \
pkg-config \
texinfo \
zlib1g-dev \
libx264-dev

libvpx-dev 
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
--prefix="$HOME/ffmpeg_build" \
--pkg-config-flags="--static" \
--extra-cflags="-I$HOME/ffmpeg_build/include" \
--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
--extra-libs="-lpthread -lm" \
--bindir="$HOME/bin" \
--enable-gpl \
--enable-libass \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libmp3lame \
--enable-libopus \
--enable-libtheora \
--enable-libvorbis \
--enable-libvpx \
--enable-libx264 \
--enable-nonfree 
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r
