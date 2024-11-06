FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer='steven@tambulilabs.com'

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params
COPY ./run.sh /run.sh
COPY ./frontend /frontend

ENV LISTEN_PORT=8000
ENV APP_HOST=proxy
ENV APP_PORT=9000

USER root

VOLUME /vol/static

RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    chmod 755 /frontend && \
    mkdir -p /vol/static/fire/frontend && \
    chmod 777 /vol/static/fire/frontend && \
    mkdir -p /vol/static/fire/backup && \
    chmod 777 /vol/static/fire/backup && \
    cp -r /frontend/* /vol/static/fire/frontend && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    chmod +x /run.sh
# Optional: Clean up the temporary directory
#rm -rf /temp/frontend



USER nginx

CMD ["/run.sh"]
