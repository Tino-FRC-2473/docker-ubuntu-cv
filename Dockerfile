# This Dockerfile is used to build an headles vnc image based on Ubuntu
# Forked from https://github.com/ConSol/docker-headless-vnc-container

FROM ubuntu:16.04

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC web based interface connect via http://localhost:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Environment config
ENV HOME=/home/default \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/dockerstartup/install \
    NO_VNC_HOME=/home/default/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x640 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
# Patch sources.list to enable fetching build-deps (See https://askubuntu.com/questions/496549/error-you-must-put-some-source-uris-in-your-sources-list)
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    vim \
    git \
    wget \
    sudo \
    net-tools \
    inetutils-ping \
    locales \
    bzip2 \
    tar \
    xz-utils \
    gcc \
    make \
    python-numpy

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install xfce UI
RUN apt-get install -y \
    supervisor \
    xfce4 \
    xfce4-terminal \
    xterm \
    && apt-get purge -y pm-utils xscreensaver*

RUN useradd -s /bin/bash default
ADD ./home/ $HOME/

### Install Python
ENV PYTHON_VERSION 3.8.1
RUN wget -q -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
    && mkdir -p /usr/src/python \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz \
    && apt-get build-dep -y python3.5 \
    && cd /usr/src/python \
    && ./configure --enable-optimizations \
    && make -j \
    && make install \
    && cd -

# Python packages
RUN pip3 install --upgrade pip && pip3 install numpy scipy matplotlib networkx opencv-python serial

### configure startup
ADD ./run $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME
RUN echo "root:root" | chpasswd && echo "default:default" | chpasswd && usermod -aG sudo default

# Setup timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER default

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
