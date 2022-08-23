FROM python:3.9-slim-bullseye

ENV PRIVACYIDEA_VERSION=3.7.3

WORKDIR /opt

RUN useradd -h /opt/privacyidea -u 1000 -g 1000 privacyidea

WORKDIR /opt/privacyidea

RUN python3 -m venv /opt/privacyidea/

RUN /bin/bash -c "source bin/activate && \
    pip install privacyidea==${PRIVACYIDEA_VERSION} && \
    pip install -r lib/privacyidea/requirements.txt && \
    pip install pymysql-sa PyMySQL gunicorn"

RUN chown -R 1000:1000 /opt/privacyidea

COPY ./entrypoint.sh /opt/privacyidea/entrypoint.sh

RUN mkdir -p /etc/privacyidea/ && chown -R 1000:1000 /etc/privacyidea

USER 1000

ENTRYPOINT ["/opt/privacyidea/entrypoint.sh"]

EXPOSE 8000
