FROM perl:5.20
RUN apt-get update && apt-get install -y libdbd-mysql-perl 
RUN perl -MCPAN -e 'install Bundle::DBI'
RUN cpanm Log::Simplest
RUN cpan DBD::mysql
COPY . /usr/src/healthcheck
WORKDIR /usr/src/healthcheck
ENV HOST=docker.for.mac.localhost
ENV USERNAME=root
ENV PASSWORD=secret
ENV PORT=3306
ENV LOG_DIR=/usr/src/healthcheck/logs
ENV TIMING=10


CMD [ "perl", "mysql_healthcheck.pl" ]
