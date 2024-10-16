# Build stage
FROM debian:latest AS build-env

# Install dependencies for Flutter
RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=stable
ARG APP=/app/

# Clone the Flutter repository
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK

# Checkout the specific Flutter version
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# Setup the Flutter path as an environmental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Run Flutter commands
RUN flutter doctor -v
RUN flutter channel stable
RUN flutter upgrade

# Enable web support and disable mobile platforms
RUN flutter config --enable-web

# Create a folder for the app and copy the source code
RUN mkdir $APP
COPY . $APP
WORKDIR $APP

# Build the Flutter web application
RUN flutter clean
RUN flutter pub get
RUN flutter build web --verbose

# Stage 2: Create the runtime environment with Nginx
FROM nginx:alpine

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built app to the Nginx server directory
COPY --from=build-env /app/build/web/ /usr/share/nginx/html/

# Expose port 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
