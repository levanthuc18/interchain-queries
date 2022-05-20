FROM golang:1.17-bullseye

RUN apt update && apt install git
WORKDIR /src/app
# These are some kind of deploy keys (?)
# COPY test test
COPY ssh_config /root/.ssh/config
ENV GIT_SSH_COMMAND="ssh -i /src/app/test -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
# RUN chmod 0600 test
RUN git config --global url."git@github.com:".insteadOf "https://github.com/"
# unclear why it's trying to pull the ingenuity-build repo
# RUN go env -w GOPRIVATE=github.com/ingenuity-build/*
COPY go.mod go.mod
COPY go.sum go.sum
COPY . .
RUN go mod tidy
RUN go build

RUN ln -s /src/app/interchain-queries /usr/local/bin
RUN adduser --system --home /icq --disabled-password --disabled-login icq -U 1000
USER icq
