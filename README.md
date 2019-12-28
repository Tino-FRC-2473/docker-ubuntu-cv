# docker-ubuntu-cv
The repo defines a Docker container for Python development. Based on the official Ubuntu 16.04 image, this image contains:
* Xfce UI
* VNC access via TigerVNC + noVNC
* Python 3.8.1
  * numpy
  * scipy
  * matplotlib
  * OpenCV 4.1.2
  * networkx
  * serial
# First-time Setup
Install Docker for your system:
* macOS: https://download.docker.com/mac/stable/Docker.dmg
* Windows: https://docs.docker.com/toolbox/toolbox_install_windows/

If this is your first time installing Docker, make sure to go into the preferences and adjust the resource limits to match your machine.

Build the docker image with
`docker build git@github.com:Tino-FRC-2473/docker-ubuntu-cv.git --tag docker-ubuntu-cv:1.0`

# Usage
Start the container with
`docker run -it -p 5901:5901 -p 6901:6901 docker-ubuntu-cv:1.0`

If you want to share a folder on your local machine with the container, use the -v option:
`docker run -it -p 5901:5901 -p 6901:6901 -v /some/local/path:/share docker-ubuntu-cv:1.0`

Login with noVNC:
Open your browser to http://localhost:6901/vnc.html and login with password `vncpassword`

Or on Mac, use the native VNC viewer with `open vnc://localhost:5901`
