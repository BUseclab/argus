FROM ubuntu:20.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y php7.4 wget php7.4-simplexml php7.4-mbstring php7.4-curl php7.4-dom php7.4-zip git

RUN cd /home && git clone https://github.com/vimeo/psalm && cd psalm && git checkout 832fc35d8da6e5bb60f059ebf5cb681b4ec2dba5
RUN cd /home && git clone https://github.com/orangelabweb/imagemagick-engine.git && cd imagemagick-engine && git checkout v.1.7.2
RUN wget https://getcomposer.org/download/latest-stable/composer.phar && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN cd /home/psalm/ && composer install --no-plugins
COPY script /home/run.sh
RUN chmod +x /home/run.sh

WORKDIR /home
