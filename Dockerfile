# Build Stage
FROM lacion/docker-alpine:gobuildimage AS build-stage

LABEL app="build-sf-envs"
LABEL REPO="https://github.com/tricky42/sf_envs"

ENV GOROOT=/usr/lib/go \
    GOPATH=/gopath \
    GOBIN=/gopath/bin \
    PROJPATH=/gopath/src/github.com/tricky42/sf_envs

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /gopath/src/github.com/tricky42/sf_envs
WORKDIR /gopath/src/github.com/tricky42/sf_envs

RUN make build-alpine

# Final Stage
FROM lacion/docker-alpine:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/tricky42/sf_envs"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/sf_envs/bin

WORKDIR /opt/sf_envs/bin

COPY --from=build-stage /gopath/src/github.com/tricky42/sf_envs/bin/sf_envs /opt/sf_envs/bin/
RUN chmod +x /opt/sf_envs/bin/sf_envs

CMD /opt/sf_envs/bin/sf_envs