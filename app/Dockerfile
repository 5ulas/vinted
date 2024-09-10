FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

ARG FLASK_SECRET_KEY
ARG OKTA_CLIENT_ID
ARG OKTA_CLIENT_SECRET
ARG OKTA_METADATA_URL

ENV FLASK_SECRET_KEY=$FLASK_SECRET_KEY
ENV OKTA_CLIENT_ID=$OKTA_CLIENT_ID
ENV OKTA_CLIENT_SECRET=$OKTA_CLIENT_SECRET
ENV OKTA_METADATA_URL=$OKTA_METADATA_URL

EXPOSE 3000

# Command to run the app
CMD ["python", "app.py"]