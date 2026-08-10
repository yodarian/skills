# Docker Setup für Laravel

Einfaches Docker-Setup mit PHP, Nginx und MySQL.

## Services

- **app**: PHP-FPM Container mit Laravel
- **nginx**: Nginx Webserver
- **mysql**: MySQL 8.0 Datenbank

## Verwendung

### Projekt starten

```bash
docker-compose up -d
```

### Projekt beenden

```bash
docker-compose down
```

### Logs anschauen

```bash
docker-compose logs -f app
```

### Datenbankmigrationen ausführen

```bash
docker-compose exec app php artisan migrate
```

### Datenbankverbindung testen

```bash
docker-compose exec mysql mysql -u laravel -p laravel -e "SELECT 1;"
# Passwort: secret
```

## URLs

- Laravel: http://localhost
- Adminer (optional): http://localhost:8080

## Persistente Daten

MySQL-Daten werden in einem Docker-Volume gespeichert und bleiben auch nach `docker-compose down` erhalten.

## Umgebungsvariablen

Die `.env`-Datei wird automatisch erstellt. Bei Bedarf anpassen:

```
DB_CONNECTION=mysql
DB_HOST=mysql
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
```
