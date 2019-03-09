#!/bin/bash
set -e

SCHEMACRAWLER_VERSION=15.05.01

echo "** Setting up SchemaCrawler v$SCHEMACRAWLER_VERSION distribution"

# Download SchemaCrawler distribution
echo "Downloading SchemaCrawler distribution"
wget -N -nv https://github.com/schemacrawler/SchemaCrawler/releases/download/v"$SCHEMACRAWLER_VERSION"/schemacrawler-"$SCHEMACRAWLER_VERSION"-distribution.zip
unzip -q -u schemacrawler-"$SCHEMACRAWLER_VERSION"-distribution.zip
SC_DIR=`pwd`/schemacrawler-"$SCHEMACRAWLER_VERSION"-distribution

# Download additional libraries to allow SchemaCrawler commands to work
echo "Downloading additional libraries to support SchemaCrawler"
cd "$SC_DIR"
cd ./_downloader
pwd
chmod +x ./download.sh

./download.sh shell
./download.sh plugins

./download.sh postgresql-embedded

./download.sh groovy
./download.sh python
./download.sh ruby

./download.sh velocity
./download.sh thymeleaf
./download.sh mustache

# Additional setup
echo "Performing additional setup of distribution"
cd "$SC_DIR"

rm ./_schemacrawler/lib/slf4j-jdk14-*.jar
cp ./examples/shell/schemacrawler-shell.* ./_schemacrawler

echo "Done"

