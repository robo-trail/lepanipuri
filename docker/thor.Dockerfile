FROM isaac-gr00t-n1.5:l4t-jp7.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-dev \
      libsm6 \
      libxext6 \
      ffmpeg \
      libhdf5-serial-dev \
      libtesseract-dev \
      libgtk-3-0 \
      libtbb12 \
      libgl1 \
      libatlas-base-dev \
      libopenblas-dev \
      build-essential \
      python3-setuptools \
      make \
      cmake \
      nasm \
      git \
      libx11-dev \
      libxrandr-dev \
      libxinerama-dev \
      libxcursor-dev \
      libxi-dev \
      lsb-release \
      software-properties-common \
      libusb-1.0-0-dev \
      libudev-dev \
      git \
      libssl-dev \
      libusb-1.0-0-dev \
      pkg-config \
      libgtk-3-dev \
    #   freeglut3 \
    #   freeglut3-dev \
      libglfw3-dev \
      libgl1-mesa-dev \
      libglu1-mesa-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /home

# Install librealsense SDK
RUN git clone --depth=1 https://github.com/IntelRealSense/librealsense.git /usr/src/librealsense \
    && cmake -S /usr/src/librealsense -B /usr/src/librealsense/build \
        -DCMAKE_BUILD_TYPE=Release  \
        -DCMAKE_C_FLAGS_RELEASE="${CMAKE_C_FLAGS_RELEASE} -s" \
        -DCMAKE_CXX_FLAGS_RELEASE="${CMAKE_CXX_FLAGS_RELEASE} -s" \
        -DPYTHON_EXECUTABLE=$(which python3) \
        -DBUILD_GRAPHICAL_EXAMPLES=OFF \
        -DBUILD_PYTHON_BINDINGS:bool=true \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TOOLS=OFF \
        -DCMAKE_INSTALL_PREFIX=/opt/librealsense \
    && cmake --build /usr/src/librealsense/build -j"$(nproc)" \
    && cmake --install /usr/src/librealsense/build

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/librealsense/lib
