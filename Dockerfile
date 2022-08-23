FROM python:3.9-slim-bullseye

ENV PRIVACYIDEA_VERSION=v3.7.3

WORKDIR /opt

RUN useradd -h /opt/privacyidea -u 1000 -g 1000 privacyidea

COPY ./entrypoint.sh /opt/privacyidea/entrypoint.sh

WORKDIR /opt/privacyidea

RUN python3 -m venv /opt/privacyidea/

RUN /bin/bash -c "source bin/activate && \
    pip install privacyidea && \
    pip install -r lib/privacyidea/requirements.txt && \
    pip install pymysql-sa && \
    pip install PyMySQL"

RUN chown -R 1000:1000 /opt/privacyidea

USER 1000

ENTRYPOINT ["/opt/privacyidea", "entrypoint.sh"]

