xhost +"local:docker@"
sudo systemctl start docker.service
docker build . -t ros:melodic-march
sudo docker run -ti --rm -e DISPLAY=$DISPLAY -v /home/thijs/Projects/MARCH/workspace:/home/thijs -v /tmp/.X11-unix:/tmp/.X11-unix ros:melodic-march
