FROM ros:melodic-ros-core-bionic

RUN apt-get update -y && apt-get full-upgrade -y && apt autoremove -y

RUN apt-get install python3-colcon-common-extensions python-pip python-wstool -y && \
    pip install --user catkin_lint && \
    python2 -m pip install --user flake8 pep8-naming flake8-blind-except flake8-string-format flake8-builtins flake8-commas flake8-quotes flake8-print flake8-docstrings flake8-import-order

RUN apt-get install python-rosdep -y

RUN export uid=1000 gid=1000 && \
    mkdir -p /tmp/home/thijs && \
    mkdir -p /home/thijs && \
    echo "thijs:x:${uid}:${gid}:thijs,,,:/home/thijs:/bin/bash" >> /etc/passwd && \
    echo "thijs:x:${uid}:" >> /etc/group && \
    echo "thijs ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/thijs && \
    chmod 0440 /etc/sudoers.d/thijs && \
    chown ${uid}:${gid} -R /tmp/home/thijs && \
    chown ${uid}:${gid} -R /home/thijs

USER thijs

ENV HOME /tmp/home/thijs
WORKDIR /tmp/home/thijs

VOLUME /home/thijs

RUN sudo rosdep init && rosdep update
RUN wstool init src https://raw.githubusercontent.com/project-march/tutorials/master/doc/getting_started/.rosinstall
RUN wstool update -t src
RUN rosdep install -y --from-paths src --ignore-src

RUN pip install numpy_ringbuffer pyqtgraph
RUN sudo apt install ros-melodic-gazebo-ros-control -y

ENV HOME /home/thijs
WORKDIR /home/thijs
