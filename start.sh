#!/bin/bash

echo "Starting Keycloak server..."
docker compose up -d

echo "Keycloak is starting..."
echo "Please wait a few seconds for the service to be ready."
echo ""
echo "Access Keycloak Admin Console at: http://localhost:8080/admin"
echo "Username: admin"
echo "Password: admin"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
