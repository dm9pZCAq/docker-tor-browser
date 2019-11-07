FROM alpine
ENV TOR_LANGUAGE en-US
ENV LIBREFOX true
# to use Librefox configuration https://github.com/intika/Librefox


RUN apk update
# dependencies:
RUN apk add alsa-lib \
    atk \
    bash \
    cairo \
    cairo-gobject \
    curl \
    dbus-glib \
    dbus-libs \
    fontconfig \
    freetype \
    gdk-pixbuf \
    glib \
    gnome-icon-theme \
    gtk+2.0 \
    gtk+3.0 \
    icu-libs \
    libffi \
    libgcc \
    libpng \
    libstdc++ \
    libx11 \
    libxcb \
    libxcomposite \
    libxdamage \
    libxext \
    libxfixes \
    libxrender \
    libxt \
    musl \
    nspr \
    nss \
    pango \
    pixman \
    sqlite-libs \
    startup-notification \
    zlib

# glibc
RUN curl -Lso /etc/apk/keys/sgerrand.rsa.pub \
        https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    function template { \
        echo "a href.*$1-[0-9]*\.[0-9]*\-r[0-9].*\.apk\""; \
    }; \
    for p in glibc glibc-bin; do \
        url=$(curl -s https://github.com/sgerrand/alpine-pkg-glibc/releases | \
              grep -om1 "$(template $p)" | cut -d'"' -f2) && \
        curl -Lo /var/cache/$p.apk https://github.com${url} && \
        apk add /var/cache/$p.apk; \
    done

# tor-browser
RUN ver=$(curl https://dist.torproject.org/torbrowser/ | \
          grep -om1 'a href.*[0-9]*\.[0-9]*\.[0-9]' | cut -d'>' -f2) && \
    url=${ver}/tor-browser-linux64-${ver}_${TOR_LANGUAGE}.tar.xz && \
    mkdir -p /tor && curl https://dist.torproject.org/torbrowser/${url} | \
                     tar xJC /tor && \
    name=$(echo /tor/*) && mv ${name}/Browser /tor && rm -rf ${name} 

# Librefox
RUN [ "${LIBREFOX}" = true ] && \
    url=$(curl -s https://github.com/intika/Librefox/releases | \
          grep -m1 'Librefox-[0-9]*\.[0-9]*.*Tor-Linux.*\.zip' | \
          cut -d'"' -f2) && \
    curl -L https://github.com${url} | unzip -oqd /tor/Browser - || return 0

# cleanup
RUN apk del curl && rm -rf /var/cache/*

RUN adduser -Dh /tor -s /sbin/nologin tor-browser
RUN addgroup tor-browser video && addgroup tor-browser audio
RUN chown tor-browser:tor-browser -R /tor
USER tor-browser
WORKDIR /tor/Browser
CMD /tor/Browser/start-tor-browser
