#!/usr/bin/env bash
go build ./Server/api.go

mv api Output/

./Output/api