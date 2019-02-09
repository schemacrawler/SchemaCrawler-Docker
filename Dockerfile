# ========================================================================
# SchemaCrawler
# http://www.schemacrawler.com
# Copyright (c) 2000-2019, Sualeh Fatehi <sualeh@hotmail.com>.
# All rights reserved.
# ------------------------------------------------------------------------
#
# SchemaCrawler is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# SchemaCrawler and the accompanying materials are made available under
# the terms of the Eclipse Public License v1.0, GNU General Public License
# v3 or GNU Lesser General Public License v3.
#
# You may elect to redistribute this code under any of these licenses.
#
# The Eclipse Public License is available at:
# http://www.eclipse.org/legal/epl-v10.html
#
# The GNU General Public License v3 and the GNU Lesser General Public
# License v3 are available at:
# http://www.gnu.org/licenses/
#
# ========================================================================

FROM openjdk:8-jdk-alpine

ARG SCHEMACRAWLER_VERSION=15.04.01

LABEL \
  "us.fatehi.schemacrawler.product-version"="SchemaCrawler ${SCHEMACRAWLER_VERSION}" \
  "us.fatehi.schemacrawler.website"="http://www.schemacrawler.com" \
  "us.fatehi.schemacrawler.docker-hub"="https://hub.docker.com/r/schemacrawler/schemacrawler"

# Install GraphViz
RUN \
  apk add --update --no-cache \
  bash \
  bash-completion \
  graphviz \
  ttf-freefont

# Copy SchemaCrawler distribution from the build directory
COPY \
    ./schemacrawler-${SCHEMACRAWLER_VERSION}-distribution/_schemacrawler /opt/schemacrawler
RUN \
    chmod +rx /opt/schemacrawler/schemacrawler.sh \
 && chmod +rx /opt/schemacrawler/schemacrawler-shell.sh

# Run the image as a non-root user
RUN \
    addgroup -g 1000 -S schcrwlr \
 && adduser -u 1000 -S schcrwlr -G schcrwlr
USER schcrwlr
WORKDIR /home/schcrwlr

# Copy configuration files for the current user
COPY \
    --chown=schcrwlr:schcrwlr \
    ./schemacrawler-${SCHEMACRAWLER_VERSION}-distribution/_testdb/sc.db \
    /home/schcrwlr/sc.db
COPY \
    --chown=schcrwlr:schcrwlr \
    ./schemacrawler-${SCHEMACRAWLER_VERSION}-distribution/_schemacrawler/config/* \
    /home/schcrwlr/

# Create aliases for SchemaCrawler
RUN \
    echo 'alias schemacrawler="/opt/schemacrawler/schemacrawler.sh"' \
    >> /home/schcrwlr/.bashrc
RUN \
    echo 'alias schemacrawler-shell="/opt/schemacrawler/schemacrawler-shell.sh"' \
    >> /home/schcrwlr/.bashrc


MAINTAINER Sualeh Fatehi <sualeh@hotmail.com>

