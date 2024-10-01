FROM debian:latest AS build-env

# Install dependencies for Flutter
RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.24.3
ARG APP=/app/

# Clone the Flutter repository
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK

# change dir to current flutter folder and make a checkout to the specific version
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# setup the flutter path as an enviromental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Start to run Flutter commands
# doctor to see if all was installes ok
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade

# Enable web support
RUN flutter config --enable-web

# Disable mobile platforms to avoid conflicts during web build
RUN flutter config --no-enable-android
RUN flutter config --no-enable-ios

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# setup new folder as the working directory
WORKDIR $APP

# Run build: 1 - clean, 2 - pub get, 3 - build web
RUN flutter clean
RUN flutter pub get

# Build the Flutter web application
RUN flutter build web

# use nginx to deploy
FROM nginx:1.25.2-alpine

# copy the info of the builded web app to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# EXPOSE PORT
EXPOSE 8080
