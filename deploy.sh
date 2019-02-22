#!/usr/bin/env bash
export PROJECT_ID="$(gcloud config get-value project -q)"

gcloud auth configure-docker

docker build -t composer -f config/docker/Dockerfile.composer .

docker build -t gcr.io/${PROJECT_ID}/wordpress-gke_nginx:latest -f config/docker/Dockerfile.nginx .

docker push gcr.io/${PROJECT_ID}/wordpress-gke_nginx:latest

docker build -t gcr.io/${PROJECT_ID}/wordpress-gke_web:latest -f config/docker/Dockerfile.web .

docker push gcr.io/${PROJECT_ID}/wordpress-gke_web:latest

kubectl delete pods --all

kubectl apply -f app.yaml