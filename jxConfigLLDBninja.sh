 #!/usr/bin/bash
 
#build error 2020.07.26

cmake -G Ninja \
    -DLLVM_TARGETS_TO_BUILD=host \
    -DLLVM_ENABLE_PROJECTS="clang;lldb" \
    -DLLDB_EXPORT_ALL_SYMBOLS=1 \
    -DCMAKE_BUILD_TYPE=Debug \
    ../llvm
