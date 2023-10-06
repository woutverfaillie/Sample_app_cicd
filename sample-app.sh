#!/bin/bash
set -euo pipefail

TEMP_DIR="tempdir"

# Check if tempdir directory already exists, and if not, create it
if [ ! -d "$TEMP_DIR" ]; then
    mkdir "$TEMP_DIR"
    mkdir "$TEMP_DIR/templates"
    mkdir "$TEMP_DIR/static"
fi

# Copy files and directories
cp sample_app.py "$TEMP_DIR/"
cp -r templates/* "$TEMP_DIR/templates/"
cp -r static/* "$TEMP_DIR/static/"

# Create Dockerfile
cat > "$TEMP_DIR/Dockerfile" << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd "$TEMP_DIR" || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a
