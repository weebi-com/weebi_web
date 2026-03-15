# Build stage
FROM debian:latest AS build-env

# Install dependencies for Flutter
RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Define variables (Flutter version must match pubspec.yaml environment.sdk and local stable)
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.29.3
ARG APP=/app/

# Clone the Flutter repository
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK

# Checkout the specific Flutter version
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# Setup the Flutter path as an environmental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Run Flutter commands (no upgrade: version is pinned above)
RUN flutter doctor -v

# Enable web support and disable mobile platforms
RUN flutter config --enable-web

# Create a folder for the app and copy the source code
RUN mkdir $APP
COPY . $APP
WORKDIR $APP

# Satisfy pubspec asset (dotenv_lcl is gitignored; web app uses config.json only at runtime)
RUN touch assets/dotenv_lcl.txt

# Build the Flutter web application
RUN flutter clean
RUN flutter pub get
RUN flutter build web --verbose

# Stage 2: Create the runtime environment with Nginx
FROM nginx:alpine

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint for runtime config injection
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the built app to the Nginx server directory
COPY --from=build-env /app/build/web/ /usr/share/nginx/html/

# Expose port 8080
EXPOSE 8080

# API_URL and other env are NOT available at build time. They are set by Cloud Run at
# container start. entrypoint.sh reads them and writes /config.json; the app fetches that
# in the browser. Set these in Cloud Run (or leave empty and use ENVIRONMENT + API_URL_PRD).
ENV API_URL="" ENVIRONMENT="" API_URL_DEV="" API_URL_PRD="" LOCALE="fr"

ENTRYPOINT ["/entrypoint.sh"]
