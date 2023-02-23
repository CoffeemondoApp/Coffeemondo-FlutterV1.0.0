FROM ubuntu:latest

RUN apt-get update -y && \ 
    apt-get install -y curl gnupg git

RUN git clone https://github.com/flutter/flutter.git -b stable

ENV PATH "$PATH:/flutter/bin"

WORKDIR /app

COPY pubspec.yaml .

COPY . .

EXPOSE 8080

RUN apt-get install unzip

CMD ["flutter", "run", "--release", "-d", "web-server", "--web-hostname", "0.0.0.0", "--web-port", "8080"]
