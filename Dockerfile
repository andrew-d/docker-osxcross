FROM debian:jessie
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Install build tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yy \
        automake            \
        bison               \
        curl                \
        file                \
        flex                \
        git                 \
        pkg-config          \
        python              \
        texinfo             \
        vim                 \
        wget

# Install osxcross
# NOTE: The Docker Hub's build machines run varying types of CPUs, so an image
# built with `-march=native` on one of those may not run on every machine - I
# ran into this problem when the images wouldn't run on my 2013-era Macbook
# Pro.  As such, we remove this flag entirely.
ENV OSXCROSS_SDK_VERSION 10.8
RUN mkdir /opt/osxcross &&                                      \
    cd /opt &&                                                  \
    git clone https://github.com/tpoechtrager/osxcross.git &&   \
    cd osxcross &&                                              \
    git checkout f5bec454d3cc8c7e2e914af9ec443a4d44458ca5 &&    \
    sed -i -e 's|-march=native||g' ./build_clang.sh ./wrapper/build.sh && \
    ./tools/get_dependencies.sh &&                              \
    curl -L -o ./tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz \
        https://s3.amazonaws.com/andrew-osx-sdks/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz && \
    yes | PORTABLE=true ./build.sh

ENV PATH $PATH:/opt/osxcross/target/bin
CMD /bin/bash
