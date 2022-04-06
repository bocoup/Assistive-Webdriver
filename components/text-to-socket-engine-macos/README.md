# Introduction

This is a speech synthesis voice for OSX. It does not output any audio, instead it sends messages over TCP when speech requests are made.

## Installation

Run `sudo xcodebuild install DSTROOT=/`
Then run `sudo pkill -f com.apple.speech.speechsynthesisd`

## Usage

1. Set up a local TCP server listening on port 4449.
1. Set speech output to Cher.
1. All speech requests will be sent as messages to the local server.
