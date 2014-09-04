FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -yq python-pip
ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
ADD . /app
RUN sphinx-build -b dirhtml /app/docs/source /app/docs/build
WORKDIR /app/docs/build
EXPOSE 80
CMD ["python", "-mSimpleHTTPServer", "80"]