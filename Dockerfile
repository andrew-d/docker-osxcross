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
RUN mkdir /opt/osxcross &&                                      \
    cd /opt &&                                                  \
    git clone https://github.com/tpoechtrager/osxcross.git &&   \
    cd osxcross &&                                              \
    git checkout 7734f4f0ed24eecbb9e852f6bba688072c5a93c3 &&    \
    ./tools/get_dependencies.sh &&                              \
    curl -L -o ./tarballs/MacOSX10.8.sdk.tar.xz https://s3.amazonaws.com/andrew-osx-sdks/MacOSX10.8.sdk.tar.xz && \
    yes | PORTABLE=true ./build.sh

ENV PATH $PATH:/opt/osxcross/target/bin
CMD /bin/bash
