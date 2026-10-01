# Stage 1: build data/*.json from the YAML sources in content/
FROM python:3.12-alpine AS data
WORKDIR /src
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY scripts/ scripts/
COPY content/ content/
COPY assets/ assets/
COPY data/publications.json data/
RUN python scripts/build_data.py

# Stage 2: serve the static website
FROM nginx:alpine

# Copy the static website files to the nginx html directory
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY src/ /usr/share/nginx/html/src/
COPY --from=data /src/data/ /usr/share/nginx/html/data/
COPY main.js /usr/share/nginx/html/main.js
COPY assets/ /usr/share/nginx/html/assets/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
