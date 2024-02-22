FROM python:3.12-alpine3.19
RUN apk add curl
COPY ./requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
WORKDIR /app
COPY . .
EXPOSE 80
CMD [ "python3","app.py" ]