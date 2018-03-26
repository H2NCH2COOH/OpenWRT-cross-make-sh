#!/bin/bash

build_root=$(readlink -f $1 2> /dev/null)
staging_dir=$(readlink -f $build_root/staging_dir/toolchain-* 2> /dev/null)
target_dir=$(readlink -f $build_root/staging_dir/target-* 2> /dev/null)

if [ ! -d "$build_root" -o ! -d "$staging_dir" -o ! -d "$target_dir" ]; then
    echo "$1 is not a build dir" 1>&2
    exit 1
fi

shift

export TOPDIR=$build_root

make -f - <<EOF
include \$(TOPDIR)/rules.mk

include \$(INCLUDE_DIR)/prereq.mk
#include \$(INCLUDE_DIR)/uclibc++.mk
include \$(INCLUDE_DIR)/package-defaults.mk

all:
	+\$(MAKE_VARS) make \$(MAKE_FLAGS) $*
EOF
