#!/bin/bash
set -ex

BOOST_MAJOR=1
BOOST_MINOR=77
BOOST_PATCH=0

wget --no-check-certificate -O /tmp/boost.tar.gz "https://sourceforge.net/projects/boost/files/boost/${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}/boost_${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}.tar.gz/download"
mkdir /tmp/boost_src/
tar -xzf /tmp/boost.tar.gz -C /tmp/boost_src/
# This helps find then nested folder irrespective of verison.
BOOST_ROOT="$( find /tmp/boost_src/* -maxdepth 0 -type d -name 'boost*' )"
cd $BOOST_ROOT

./bootstrap.sh --with-libraries=program_options,system,thread,test,chrono,date_time,atomic
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.6" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.7" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.8" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.9" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.10" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.11" install
./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static --with-python --user-config="/python-config.jam" python="3.12" install

cd /
rm -rf /tmp/boost_src/ /tmp/boost.tar.gz
