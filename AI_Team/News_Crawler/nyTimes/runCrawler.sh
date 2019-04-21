#!/usr/bin/env bash
go build ./Crawler/rssCrawler.go

mv rssCrawler Output/

./Output/rssCrawler 1