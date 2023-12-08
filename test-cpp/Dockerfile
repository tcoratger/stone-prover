FROM ciimage/python:3.9 as base_image

# Installation de Zig
RUN mkdir -p /zig
WORKDIR /zig

# # Téléchargement de Zig
# RUN curl -LO https://ziglang.org/builds/zig-linux-aarch64-0.12.0-dev.1802+56deb5b05.tar.xz
# RUN tar -xf zig-linux-aarch64-0.12.0-dev.1802+56deb5b05.tar.xz
# RUN mv zig-linux-aarch64-0.12.0-dev.1802+56deb5b05 /zig/local

# Téléchargement de Zig
RUN curl -LO https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.1802+56deb5b05.tar.xz
RUN tar -xf zig-linux-x86_64-0.12.0-dev.1802+56deb5b05.tar.xz
RUN mv zig-linux-x86_64-0.12.0-dev.1802+56deb5b05 /zig/local


# Copie des fichiers pour la construction du code C++
COPY functions1.h /app/
COPY functions1.cpp /app/
COPY functions2.h /app/
COPY functions2.cpp /app/
COPY main.cpp /app/
COPY build.zig /app/

WORKDIR /app

# Exécution de votre commande Zig
RUN /zig/local/zig build


