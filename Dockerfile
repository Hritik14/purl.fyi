FROM python:3.8

WORKDIR /app
COPY . .

RUN make
CMD make run
