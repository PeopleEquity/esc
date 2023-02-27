#!/bin/bash
# Copyright © Aptos Foundation
# SPDX-License-Identifier: Apache-2.0

###########################################
# Build and package a release for the CLI #
###########################################

# Note: This must be run from the root of the aptos-core repository
# 备注：该脚本必须在源码根目录下运行

set -e

# @EquityShareChain:【更新】
NAME='esc-cli'
CRATE_NAME='aptos'
CARGO_PATH="crates/$CRATE_NAME/Cargo.toml"
PLATFORM_NAME="$1"

# @EquityShareChain:【新增】用于将运行产物和源码解耦
PRODUCT_PATH='../../../Products/cli/' 
if [ ! -d $PRODUCT_PATH ];then
	mkdir -p $PRODUCT_PATH
fi

# Grab system information
ARCH=`uname -m`
OS=`uname -s`
VERSION=`cat "$CARGO_PATH" | grep "^\w*version =" | sed 's/^.*=[ ]*"//g' | sed 's/".*$//g'`

echo "Building release $VERSION of $NAME for $OS-$PLATFORM_NAME"

# @EquityShareChain:【更新】用于将运行产物和源码解耦
cargo build -p $CRATE_NAME --profile cli --target-dir $PRODUCT_PATH

cd target/cli/

# Compress the CLI
ZIP_NAME="$NAME-$VERSION-$PLATFORM_NAME-$ARCH.zip"

echo "Zipping release: $ZIP_NAME"
zip $ZIP_NAME $CRATE_NAME
mv $ZIP_NAME $PRODUCT_PATH
