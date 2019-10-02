FROM python:3

ENV PYTHONUNBUFFERED 1
ENV http_proxy http://proxy.indra.es:8080
ENV https_proxy http://proxy.indra.es:8080

RUN mkdir /app
WORKDIR /app

ADD conf/requiements.pip /app/
ADD src/reconf /app/reconf
ADD src/api /app/api
ADD src/manage.py /app/
ADD conf/startServer.sh /app/

RUN chmod 755 /app/startServer.sh
RUN pip3 install -r requiements.pip
RUN apt update
RUN apt install nginx -y
RUN rm -f /etc/nginx/sites-enabled/default

ADD conf/nginx.conf /etc/nginx/

EXPOSE 90 8000