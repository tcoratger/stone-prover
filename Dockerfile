FROM ciimage/python:3.9 as base_image

RUN mkdir -p /deps
WORKDIR /deps

RUN curl https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.1802+56deb5b05.tar.xz -O
RUN tar -xf zig-linux-x86_64-0.12.0-dev.1802+56deb5b05.tar.xz
RUN mv zig-linux-x86_64-0.12.0-dev.1802+56deb5b05/ local/

COPY install_deps.sh /app/
COPY script_build.py /app/
COPY build.zig /app/

RUN /app/install_deps.sh


COPY CMakeLists.txt /app/
COPY src /app/src
COPY e2e_test /app/e2e_test

WORKDIR /app/
