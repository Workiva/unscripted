FROM google/dart:2.1.0 as build
RUN pub global activate dependency_validator
WORKDIR /build/
ADD . /build/
RUN echo "Starting Dart 2 script sections" && \
	pub get && \
	dartanalyzer lib test example && \
	pub run test test/all_tests.dart -p vm  && \
	pub global run dependency_validator && \
	echo "Dart 2 Script sections completed"

FROM google/dart:1.24.3
WORKDIR /build/
ADD . /build/
RUN echo "Starting the script sections" && \
	dartfmt --set-exit-if-changed -n lib test tool example && \
	pub get && \
	pub run test test/all_tests.dart -p vm && \
	tar -czvf unscripted.pub.tgz pubspec.yaml lib README.md LICENSE && \
	echo "Script sections completed"
ARG BUILD_ARTIFACTS_PUBSPEC_LOCK=/build/pubspec.lock
ARG BUILD_ARTIFACTS_PUB=/build/unscripted.pub.tgz
FROM scratch
