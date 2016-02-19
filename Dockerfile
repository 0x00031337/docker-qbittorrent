FROM debian:jessie

MAINTAINER Werner Beroux <werner@beroux.com>

# 1. Install qBittorrent-NoX
# 2. Create symbolic links to simplify mounting
RUN set -x \
    && apt-get update \
    && apt-get install -y qbittorrent-nox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd --system --uid 520 -m --shell /usr/sbin/nologin qbittorrent \

    && mkdir -p /home/qbittorrent/.config/qBittorrent \
    && chown qbittorrent:qbittorrent /home/qbittorrent/.config/qBittorrent \
    && ln -s /home/qbittorrent/.config/qBittorrent /config \

    && mkdir -p /home/qbittorrent/.local/share/data/qBittorrent \
    && chown qbittorrent:qbittorrent /home/qbittorrent/.local/share/data/qBittorrent \
    && ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents \

    && mkdir /downloads \
    && chown qbittorrent:qbittorrent /downloads

# Default configuration file.
ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /

VOLUME /config
VOLUME /torrents
VOLUME /downloads

EXPOSE 8080
EXPOSE 6881

USER qbittorrent

ENTRYPOINT ["/entrypoint.sh"]
CMD ["qbittorrent-nox"]
