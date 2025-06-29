FROM alpine:3.22

ARG USER_ID=14
ARG GROUP_ID=50

LABEL Description="vsftpd Docker image based on Centos 7. Supports passive mode, SSL and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd fauria/vsftpd" \
	Version="1.0"

RUN apk add vsftpd db-utils db

RUN sed -i "s/^ftp:x:[0-9]*:[0-9]*/ftp:x:${USER_ID}:${GROUP_ID}/" /etc/passwd \
 && sed -i "s/^ftp:x:[0-9]*/ftp:x:${GROUP_ID}/" /etc/group


ENV FTP_USER=**String**
ENV FTP_PASS=**Random**
ENV PASV_ADDRESS=**IPv4**
ENV PASV_ADDR_RESOLVE=NO
ENV PASV_ENABLE=YES
ENV PASV_MIN_PORT=21100
ENV PASV_MAX_PORT=21110
ENV XFERLOG_STD_FORMAT=NO
ENV LOG_STDOUT=**Boolean**
ENV FILE_OPEN_MODE=0666
ENV LOCAL_UMASK=077
ENV REVERSE_LOOKUP_ENABLE=YES
ENV PASV_PROMISCUOUS=NO
ENV PORT_PROMISCUOUS=NO
ENV SSL_ENABLE=NO
ENV TLS_CERT=cert.pem
ENV TLS_KEY=key.pem
ENV SSL_REUSE=YES
ENV SSL_CIPHERS=HIGH


COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd
VOLUME /etc/vsftpd/cert

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
