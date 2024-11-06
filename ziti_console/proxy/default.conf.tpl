server {
    listen ${LISTEN_PORT};


    root /vol/static/fire/frontend/dist;
    index index.html index.htm index.nginx-debian.html;

    location / {
        client_max_body_size  10M;
        try_files $uri $uri/ /index.html;
    }


}
