# Hardened image for secure web browsing using Brave Browser
FROM localhost/fedora-toolbox-gui:latest

USER root

# Install Brave Browser
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    dnf -y install brave-browser && \
    dnf clean all

# Special flag for Brave
ENV OZONE_PLATFORM=wayland

CMD ["brave-browser", "--ozone-platform=wayland", "--enable-features=UseOzonePlatform"]