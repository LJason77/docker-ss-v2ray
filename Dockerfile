FROM golang:alpine AS builder

LABEL maintainer "LJason <https://ljason.cn>"

RUN wget -qq https://github.com/shadowsocks/v2ray-plugin/archive/master.zip && \
	unzip master.zip && cd v2ray-plugin-master && \
	go build && cp v2ray-plugin /usr/bin/v2ray-plugin

FROM alpine

COPY --from=builder /usr/bin/v2ray-plugin /usr/bin/v2ray-plugin

RUN apk add -qq --no-cache --virtual .build-deps git autoconf automake build-base c-ares-dev libev-dev libtool libsodium-dev linux-headers mbedtls-dev pcre-dev && \
	git clone --depth 1 https://github.com/shadowsocks/shadowsocks-libev.git && \
	cd shadowsocks-libev && git submodule init && git submodule update && \
	./autogen.sh && ./configure --prefix=/usr --disable-documentation && make install && \
	apk add --no-cache privoxy ca-certificates rng-tools $(scanelf --needed --nobanner /usr/bin/ss-* | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u) && \
	cd .. && git clone --depth 1 https://github.com/jech/polipo.git && \
	cd polipo && make && install polipo /usr/local/bin/ && \
	mkdir -p /usr/share/polipo/www /var/cache/polipo && \
	apk del -qq --purge .build-deps && \
	cd .. && rm -rf shadowsocks-libev polipo /var/cache/apk/* && \
	echo -e 'daemonise = true\nproxyAddress = "0.0.0.0"\nsocksParentProxy = "127.0.0.1:1080"\nsocksProxyType = socks5\nchunkHighMark = 50331648\nobjectHighMark = 16384\nserverMaxSlots = 64\nserverSlots = 16\nserverSlots1 = 32' > /polipo

COPY files /etc/privoxy/

EXPOSE 1080 8118 8123

CMD polipo -c /polipo && privoxy /etc/privoxy/config && ss-local -c /etc/shadowsocks.json