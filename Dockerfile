# Use a lightweight Nginx image as a base
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the contents of the local 'assets' directory to the container
COPY assets /usr/share/nginx/html/assets

# Copy the 'index.html' file to the container
COPY index.html .

# Expose the default Nginx port
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]

