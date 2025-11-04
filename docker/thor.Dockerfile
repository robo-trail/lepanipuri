ARG JETSON_PYTORCH_MAJOR=25
ARG JETSON_PYTORCH_MINOR=08
ARG DOCKER_IMG_REPO="nvcr.io/nvidia/pytorch"

# Base image for thor docker
ARG BASE_IMAGE=${DOCKER_IMG_REPO}:${JETSON_PYTORCH_MAJOR}.${JETSON_PYTORCH_MINOR}-py3
FROM ${BASE_IMAGE}

# Install base dependencies
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

# Set default working directory
WORKDIR /workspace

COPY pyproject.toml .

# Set to get precompiled jetson wheels
RUN export PIP_INDEX_URL=https://pypi.jetson-ai-lab.io/sbsa/cu130 && \
    export PIP_TRUSTED_HOST=pypi.jetson-ai-lab.io && \
    pip3 install --upgrade pip setuptools && \
    pip3 install -e .[thor]

# Build and install decord
RUN cd /tmp && \
    git clone https://git.ffmpeg.org/ffmpeg.git && \
    cd ffmpeg && \
    git checkout n4.4.2 && \
    ./configure --enable-shared --enable-pic --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && \
    git clone --recursive https://github.com/dmlc/decord && \
    cd decord && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make && \
    cd ../python && \
    python3 setup.py install --user && \
    cd /workspace && \
    rm -rf /tmp/ffmpeg /tmp/decord

# Set decord library path environment variable
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.local/decord/

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
