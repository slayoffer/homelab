# Use the official nginx image as a parent image
FROM nginx:latest

# Copy the HTML file and the video file into the container
COPY ./index.html /usr/share/nginx/html/index.html
COPY ./rickroll.mp4 /usr/share/nginx/html/rickroll.mp4

# Expose port 80
EXPOSE 80