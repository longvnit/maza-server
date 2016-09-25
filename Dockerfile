FROM longvnit/centos6-webserver:latest
MAINTAINER longvnit
LABEL Description="This image is used to MAZA" Vendor="MAZA" Version="1.0"

COPY docker-entrypoint.sh /usr/local/bin

RUN useradd maza

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh

RUN chown maza.maza -R /home/maza

RUN chmod 755 /home/maza

ENTRYPOINT ["docker-entrypoint.sh"]

VOLUME /home/maza

RUN ln -s /webserver/php/bin/php /usr/bin

EXPOSE 80 9000

CMD ["bash"]


