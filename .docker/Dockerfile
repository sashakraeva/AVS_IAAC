# Base Image: ROS Noetic
ARG ROS_DISTRO=noetic
FROM ros:$ROS_DISTRO-ros-base AS base

# Environment Variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Base ROS installation with essential tools
FROM base AS ros

RUN apt-get update && apt-get install -y --no-install-recommends \
    ssh \
    git \
    curl \
    wget \
    lsb-release \
    build-essential \
    cmake \
    python3-pip \
    python3-catkin-tools \
    python3-rosdep \
    python3-rosinstall-generator \
    python3-vcstool \
    python3-pykdl \
    terminator \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install essential Python libraries
RUN pip3 install --no-cache-dir --upgrade pip \
    numpy \
    matplotlib \
    opencv-python \
    pyquaternion \
    python-dateutil \
    cython \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ROS Noetic packages for simulation
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-gazebo-ros-pkgs \
    ros-$ROS_DISTRO-gazebo-ros-control \
    ros-$ROS_DISTRO-navigation \
    ros-$ROS_DISTRO-xacro \
    ros-$ROS_DISTRO-robot-state-publisher \
    ros-$ROS_DISTRO-joint-state-publisher \
    ros-$ROS_DISTRO-joint-trajectory-controller \
    ros-$ROS_DISTRO-diagnostic-updater \
    ros-$ROS_DISTRO-image-transport-plugins \
    ros-$ROS_DISTRO-depthimage-to-laserscan \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y \
    ignition-edifice \
    ros-noetic-ros-ign \
    ros-noetic-ros-ign-gazebo

# Set up ROS workspace
WORKDIR /
RUN mkdir -p dev_ws/src
WORKDIR /dev_ws/src

# niceness permissions (for ur driver use without Prempt-RT)
RUN echo "* - nice -15" >> /etc/security/limits.conf

# Build workspace
FROM ros AS build

# Ensure .docker files are copied
COPY . /dev_ws/src/

WORKDIR /dev_ws

# RUN chown -R sashanosense /usr/local/lib/python3.8/dist-packages/

RUN ["/bin/bash", "-c", "source /opt/ros/$ROS_DISTRO/setup.bash &&\
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release &&\
    catkin build \
    "]

FROM build AS bash

RUN ["/bin/bash", "-c", "cp /dev_ws/src/.docker/setup.bash /dev_ws/setup.bash && chmod 777 /dev_ws/setup.bash"]
RUN ["/bin/bash", "-c", "cp /dev_ws/src/.docker/entrypoint.bash / && chmod 777 /entrypoint.bash"]
ENTRYPOINT ["bash", "/entrypoint.bash" ]

CMD ["bash"]


FROM build as dev

SHELL ["zsh", "chsh -s ~/.zshrc" ]

RUN ["/bin/bash", "-c", "cp /dev_ws/src/.docker/setup.zsh /dev_ws/setup.zsh && chmod 777 /dev_ws/setup.zsh"]
RUN ["/bin/bash", "-c", "cp /dev_ws/src/.docker/entrypoint.zsh / && chmod 777 /entrypoint.zsh"]

ENTRYPOINT ["zsh", "/entrypoint.zsh" ]

CMD ["zsh"]