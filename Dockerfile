FROM google/dart:2.0.0 as build

ARG BUILD_ID
ARG BUILD_NUMBER
ARG BUILD_URL
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG GIT_TAG
ARG GIT_COMMIT_RANGE
ARG GIT_HEAD_URL
ARG GIT_MERGE_HEAD
ARG GIT_MERGE_BRANCH
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
WORKDIR /build/
ADD . /build/
RUN echo "=== Setting up ssh ===" && \
	mkdir /root/.ssh && \
	echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts" && \
	echo "$GIT_SSH_KEY" > "/root/.ssh/id_rsa" && \
	chmod 700 /root/.ssh/ && \
	chmod 600 /root/.ssh/id_rsa && \
	eval "$(ssh-agent -s)"  && \
	ssh-add /root/.ssh/id_rsa
RUN echo "Starting the script sections" && \
	timeout 5m pub get && \
	pub run test && \
	pub run dependency_validator && \
	tar -czvf unscripted.pub.tgz pubspec.yaml lib README.md LICENSE && \
	echo "Script sections completed"
ARG BUILD_ARTIFACTS_PUBSPEC_LOCK=/build/pubspec.lock
ARG BUILD_ARTIFACTS_PUB=/build/unscripted.pub.tgz
FROM scratch
