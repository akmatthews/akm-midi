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

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
    && sudo apt-get update \
    && sudo apt-get install -y google-chrome-stable \
    && sudo rm -rf /var/lib/apt/lists/*

# Accept Android licenses
RUN yes | /home/gitpod/flutter/bin/flutter doctor --android-licenses || true

# Pre-download development binaries
RUN /home/gitpod/flutter/bin/flutter precache