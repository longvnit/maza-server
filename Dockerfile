FROM longvnit/centos6-webserver:latest
MAINTAINER longvnit
LABEL Description="This image is used to MAZA" Vendor="MAZA" Version="1.0"

COPY setup.sh /usr/local/bin

RUN useradd maza

RUN chmod +x /usr/local/bin/setup.sh

RUN /usr/local/bin/setup.sh

VOLUME /home/maza

RUN ln -s /webserver/php/bin/php /usr/bin

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["supervisord"]

CMD ["bash"]
