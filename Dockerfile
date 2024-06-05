
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY assets /usr/share/nginx/html/assets
COPY index.html .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

