ARG TAG=5.0
FROM ubuntu:20.10

# Port argument to new scope
ARG TAG
# Powershell is used to install dotnet using microsoft's script
ARG PWSH_VERSION="7.1.3"
ARG DOTNET_VERSION=${TAG}
ARG DEBIAN_FRONTEND="noninteractive"

ARG BUILD_DEP="\
  software-properties-common \
  unzip \
  wget"

# 'stable' is 6.0.X which produced an error on dotnet48 prompting to update
# wine to 6.6. Prefer 'staging'
ARG WINE_BRANCH="staging"

# Turn off wine install Fixme warnings
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEPREFIX=/root/.wine-dotnet
# According to logs, everything supposedly works better on 32bit arch
ENV WINEARCH=win32

# dotnet executable path
ENV WINEPATH=${WINEPREFIX}/drive_c/users/root/AppData/Local/Microsoft/dotnet

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
        zenity \
        # contains 'unbuffer', a pseudo-tty (pty) mandatory to interactive needs
        expect \
    # Install powershell
    && mkdir -p /tmp/pwsh \
    && wget -nv -O /tmp/pwsh/pwsh.zip https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/PowerShell-${PWSH_VERSION}-win-x86.zip \
    #   Ignore unzip warning "zip appears to use backslashes as path separators"
    && { unzip /tmp/pwsh/pwsh.zip -d /tmp/pwsh || true; } \
    # Install wine
    && wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
    && apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -yqq --install-recommends winehq-${WINE_BRANCH} \
    # Install winetricks
    && wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks \
    # Create prefix and make sure everything is up-to-date
    && wineboot --update \
    # Install winetricks plugin no crash dialog, unsure if necessary
    && winetricks --force --unattended nocrashdialog \
    # Install dotnet
    && wget -nv -O dotnet-install.ps1 https://dot.net/v1/dotnet-install.ps1 \
    && unbuffer wine /tmp/pwsh/pwsh.exe dotnet-install.ps1 -c ${DOTNET_VERSION} \
    # Cleanup
    && apt-get remove --purge -yqq $BUILD_DEP \
    && apt-get autoremove -yqq \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pwsh
