FROM alpine:3.19.1

RUN apk add bash curl

COPY ./pinger.sh /usr/local/bin/pinger

RUN chmod +x /usr/local/bin/pinger

RUN echo "* * * * * /bin/bash /usr/local/bin/pinger > /dev/stdout" > /etc/crontabs/root

CMD ["crond", "-f", "-l", "2"]