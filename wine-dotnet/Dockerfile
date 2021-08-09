ARG TAG=20.10
FROM ubuntu:${TAG}

ARG DOTNET="dotnet48"
ARG DEBIAN_FRONTEND="noninteractive"
ARG BUILD_DEP="\
  git \
  software-properties-common"
  
# stable is 6.0.X which produces an error on dotnet48 prompting to update wine to 6.6. Trying staging
ARG WINE_BRANCH="staging"

# Turn off wine install Fixme warnings
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEPREFIX=/root/.net
# According to logs, everything supposedly works better on 32bit arch
ENV WINEARCH=win32

# Install prerequisites
RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gosu \
        gpg-agent \
        tzdata \
        winbind \
        $BUILD_DEP \
        # required for winetricks
        cabextract \
        p7zip \
        unzip \
        wget \
        xvfb \
        zenity \
    # Install wine
    && wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
    && apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -yqq --install-recommends winehq-${WINE_BRANCH} \
    # Run wine configuration
    && xvfb-run -e /dev/stdout winecfg \
    # Install winetricks
    && wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks \
    # Install dotnet
    && xvfb-run -e /dev/stdout winetricks --unattended --force ${DOTNET} dotnet_verifier \
    # Verify
    && xvfb-run -e /dev/stdout wine netfx_setupverifier.exe
    # Cleanup
    && apt-get remove --purge -yqq $BUILD_DEP \
    && apt-get autoremove -yqq \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache
