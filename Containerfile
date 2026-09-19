# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Base Image
FROM quay.io/fedora/fedora-silverblue:45

RUN rm -rf /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

# Remove GNOME bloat
RUN dnf5 -y remove \
  firefox firefox-langpacks \
  gnome-tour gnome-connections gnome-contacts \
  gnome-maps gnome-music gnome-weather gnome-calculator \
  gnome-calendar gnome-characters gnome-clocks gnome-font-viewer \
  gnome-logs gnome-system-monitor gnome-remote-desktop \
  gnome-software gnome-software-rpm-ostree \
  simple-scan totem yelp malcontent \
  gnome-classic-session gnome-extensions-app \
  --allowerasing --skip-unavailable

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
