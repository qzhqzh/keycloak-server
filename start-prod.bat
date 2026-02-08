@echo off
echo Starting Keycloak production environment...
echo.

if not exist ".env" (
    echo Error: .env file not found!
    echo Please copy .env.example to .env and configure your settings.
    pause
    exit /b 1
)

if not exist "ssl" (
    echo Creating ssl directory...
    mkdir ssl
)

if not exist "ssl\fullchain.pem" (
    echo Warning: SSL certificates not found in ssl directory!
    echo Please obtain SSL certificates and place them in ssl directory:
    echo   - ssl/fullchain.pem
    echo   - ssl/privkey.pem
    echo.
    echo You can use Let's Encrypt certbot to obtain free certificates:
    echo   certbot certonly --standalone -d your-domain.com
    pause
)

docker compose -f docker-compose.prod.yml up -d

echo.
echo Keycloak production environment is starting...
echo Please wait for the services to be ready.
echo.
echo Access Keycloak Admin Console at: https://your-domain.com/admin
echo.
echo To view logs: docker compose -f docker-compose.prod.yml logs -f
echo To stop: docker compose -f docker-compose.prod.yml down
pause
