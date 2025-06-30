FROM ubuntu:rolling

LABEL Description="vsftpd Docker image based on Alpine. Supports passive mode, SSL and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd cyr-ius/vsftpd" \
	Version="1.0"

RUN apt update -y && apt dist-upgrade -y
RUN apt install -y vsftpd db-util iproute2

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
ENV ENABLE_TLSv1=YES


COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/bin/

RUN chmod +x /usr/bin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd
VOLUME /etc/vsftpd/cert

EXPOSE 20 21
CMD ["/usr/bin/run-vsftpd.sh"]