#!/usr/bin/bash

./deleteCache.sh

./configure --target=x86_64-linux-gnu --host=x86_64-linux-gnu --build=x86_64-linux-gnu CFLAGS_FOR_BUILD="-g -O0 -pg" CXXFLAGS_FOR_BUILD="-g -O0 -pg" CXXFLAGS="-g -O0 -pg" CFLAGS="-g -O0 -pg" CFLAGS_FOR_TARGET="-g -O0 -pg" CXXFLAGS_FOR_TARGET="-g -O0 -pg" 
