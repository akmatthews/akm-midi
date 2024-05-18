FROM gitpod/workspace-full

# Install Flutter
RUN sudo apt-get update \
    && sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa libgtk-3-dev \
    && sudo rm -rf /var/lib/apt/lists/*

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /home/gitpod/flutter \
    && /home/gitpod/flutter/bin/flutter doctor

# Add Flutter to PATH
ENV PATH="/home/gitpod/flutter/bin:/home/gitpod/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Accept Android licenses
RUN yes | /home/gitpod/flutter/bin/flutter doctor --android-licenses || true

# Pre-download development binaries
RUN /home/gitpod/flutter/bin/flutter precache