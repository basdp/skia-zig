#!/bin/sh

zig translate-c includes.c -Iskia > src/main.zig
