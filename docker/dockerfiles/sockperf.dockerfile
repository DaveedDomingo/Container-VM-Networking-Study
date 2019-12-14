FROM ubuntu:18.04
EXPOSE 11111

RUN apt-get update \
    && apt-get install telnet traceroute dnsutils curl wget -y

COPY sockperf sockperf
RUN mv sockperf /usr/local/bin/
RUN chmod a+x /usr/local/bin/sockperf
ENTRYPOINT ["/usr/local/bin/sockperf"]
