FROM ubuntu:16.04

MAINTAINER tuapmhd "tuanpmhd@gmail.com"

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev libffi-dev libssl-dev libglib2.0-0 libsm6 libxext6 libxrender-dev

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN pip3 install virtualenv 

COPY . /app/

WORKDIR /app

RUN virtualenv -p python3 venv

RUN /bin/bash -c "source venv/bin/activate"

RUN pip3 install -r requirements.txt

RUN python3 -m spacy download en

RUN chmod +x run.sh 

ENTRYPOINT ["./run.sh"]

