#!/usr/bin/env bash

cite about-plugin
about-plugin 'go environment variables & path configuration'

export GOROOT=${GOROOT:-/usr/local/go}
pathmunge "${GOROOT}/bin"
export GOPATH=${GOPATH:-"$HOME/go"}
pathmunge "${GOPATH}/bin"
