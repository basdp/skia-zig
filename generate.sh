#!/bin/sh

mkdir -p src
zig translate-c includes.c -Iskia > src/main.zig
