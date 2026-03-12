# Frontend estático: petición La Paz (nginx)
FROM nginx:alpine

# Copiar assets al directorio por defecto de nginx
COPY public/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
