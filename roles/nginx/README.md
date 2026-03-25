# Role: nginx

## Doel
Installeert en configureert nginx via één herbruikbare template.
Varianten (server_name, listen_port) worden bepaald via group_vars.

## Wat doet deze role?
- Installeert nginx
- Start en enablet de service
- Deployt één vhost config via template naar /etc/nginx/conf.d/
- Herstart nginx enkel bij relevante config-wijziging (handler)

## Belangrijkste variabelen

| Variabele             | Omschrijving                    | Standaard       |
|-----------------------|---------------------------------|-----------------|
| `nginx_server_name`   | server_name in de vhost config  | `localhost`     |
| `nginx_listen_port`   | Poort waarop nginx luistert     | `80`            |
| `nginx_vhost_filename`| Bestandsnaam in conf.d/         | `labo07.conf`   |
| `nginx_webroot`       | Document root                   | `/var/www/html` |

## Varianten
- `web_blue` (rocky1): poort 8080, server_name blue.lab
- `web_green` (debian1): poort 8081, server_name green.lab

## Aannames
- /etc/nginx/conf.d/ bestaat (standaard bij nginx op Rocky en Debian)
