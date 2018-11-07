FROM google/dart:2.0.0 as build
WORKDIR /build/
ADD . /build/
RUN echo "Starting Dart 2 script sections" && \
	timeout 5m pub get && \
	dartanalyzer lib test example && \
	pub run build_runner test -- -p vm -p chrome && \
	pub run dependency_validator && \
	echo "Dart 2 Script sections completed"

FROM google/dart:1.24.3
WORKDIR /build/
ADD . /build/
RUN echo "Starting the script sections" && \
	dartfmt --set-exit-if-changed -n lib test tool example && \
	timeout 5m pub get && \
	pub run test && \
	tar -czvf unscripted.pub.tgz pubspec.yaml lib README.md LICENSE && \
	echo "Script sections completed"
ARG BUILD_ARTIFACTS_PUBSPEC_LOCK=/build/pubspec.lock
ARG BUILD_ARTIFACTS_PUB=/build/unscripted.pub.tgz
FROM scratch
