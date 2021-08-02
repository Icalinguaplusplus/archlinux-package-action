#!/bin/bash

# Set path
# echo '::group::Copying file from $WORKPATH to /tmp/gh-action'
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PATH
# # Set path permision
# sudo -u builder cp -rfv $WORKPATH /tmp/gh-action
# cd /tmp/gh-action
# echo '::endgroup::'
cd $GITHUB_WORKSPACE/$INPUT_PATH
# Update checksums
if [[ $INPUT_UPDPKGSUMS == true ]]; then
    echo '::group::Updating checksums on PKGBUILD'
    sudo -u builder updpkgsums
    echo '::endgroup::'
fi

# Generate .SRCINFO
if [[ $INPUT_SRCINFO == true ]]; then
    echo '::group::Generating new .SRCINFO based on PKGBUILD'
    sudo -u builder makepkg --printsrcinfo >.SRCINFO
    echo '::endgroup::'
fi

# Validate with namcap
if [[ $INPUT_NAMCAP == true ]]; then
    echo '::group::Validating PKGBUILD with namcap'
    namcap -i PKGBUILD
    echo '::endgroup::'
fi

# Run makepkg
if [[ -n "$INPUT_FLAGS" ]]; then
    echo '::group::Running makepkg with flags'
    $INPUT_ENVS sudo -u builder makepkg $INPUT_FLAGS
    echo '::endgroup::'
fi

# echo '::group::Copying files from /tmp/gh-action to $WORKPATH'
# cp -fv /tmp/gh-action/*.pkg.* $WORKPATH/
# echo '::endgroup::'
