#!/bin/sh -eu

# gnat is debian's Ada compiler, part of GCC, and gprbuild is the tool that
# builds an Ada program from its project file. Installing them from the
# floating base image takes whichever release that debian carries, so the
# version is resolved when the image is built rather than written down here,
# where it would pin the image to the release that was current when someone
# last edited this file.
apt-get update
apt-get install --yes --no-install-recommends gnat gprbuild

# Recorded in /versions.json and read by the install.sh of images built on
# this one, so both state the version this image actually holds. The compiler is asked
# rather than the package index, so a version recorded here is one the image
# can run. Its first line reads "GNAT 14.2.0".
readonly GNAT_VERSION=$(gnat --version | sed --quiet '1s/^GNAT \([0-9][0-9.]*\).*/\1/p')

# An empty version means the banner has been reworded rather than that gnat
# has gone, so stop here and say so instead of recording nothing.
if [ -z "${GNAT_VERSION}" ]; then
  echo 'Could not read a version from gnat --version' >&2
  exit 1
fi

# The language is named Ada, as a learner knows it, though the version is
# gnat's: that is the compiler which implements it here.
cat > /versions.json <<EOF
{
  "language": {
    "name": "Ada",
    "version": "${GNAT_VERSION}"
  },
  "test_frameworks": []
}
EOF

rm -rf /var/lib/apt/lists/*
