FROM python:3

ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

ADD scripts/requiements.pip /app/
ADD scripts/startServer.sh /app/
ADD src/reconf/reconf /app/reconf
ADD src/reconf/api /app/api
ADD src/reconf/manage.py /app/

RUN chmod 755 /app/startServer.sh
RUN pip3 install -r requiements.pip
RUN apt update
RUN apt install nginx -y

EXPOSE 90 8000
