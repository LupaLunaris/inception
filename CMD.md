# CMD

## Commandes utiles pour la correction

`tree -L 5`
Affiche l'arbre/structure du projet

`docker compose -f srcs/docker-compose.yml ps`  
Affiche l'etat des 3 services du projet (`nginx`, `wordpress`, `mariadb`).

`docker ps`  
Affiche les conteneurs Docker en cours d'execution.

`docker ps -a`  
Affiche tous les conteneurs, y compris ceux qui ont plante ou se sont arretes.

`docker network ls`  
Affiche les reseaux Docker existants.

`docker volume ls`  
Affiche les volumes Docker existants.

`docker volume inspect mariadb_data`  
Affiche les details du volume de MariaDB.

`docker volume inspect wordpress_data`  
Affiche les details du volume de WordPress.

`ls -la /home/jpaulis/data`  
Affiche le dossier de persistance sur l'hote.

`ls -la /home/jpaulis/data/mariadb | head`  
Permet de verifier que les fichiers de la base existent bien sur l'hote.

`ls -la /home/jpaulis/data/wordpress | head`  
Permet de verifier que les fichiers WordPress existent bien sur l'hote.

`curl -k -I https://jpaulis.42.fr`  
Teste que le site repond bien en HTTPS.

`curl -I http://jpaulis.42.fr || true`  
Permet de verifier que le site n'est pas accessible comme attendu en HTTP quand le sujet impose HTTPS.

`docker compose -f srcs/docker-compose.yml exec nginx sh -lc 'echo | openssl s_client -connect 127.0.0.1:${NGINX_PORT} -servername "${DOMAIN_NAME}" 2>/dev/null | grep -E "Protocol|Cipher|Verify return code"'`  
Affiche les informations TLS si Nginx ecoute en HTTPS sur le port configure.

`docker exec -it srcs-nginx-1 ls -l /etc/nginx/ssl`  
Permet de verifier que le certificat et la cle SSL existent dans le conteneur Nginx.

`docker exec -it srcs-nginx-1 openssl x509 -in /etc/nginx/ssl/nginx.crt -text -noout | grep Subject`  
Affiche le sujet du certificat SSL pour verifier le domaine.

`docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"'`  
Permet de verifier que MariaDB fonctionne et que la base `wordpress` existe avec le compte root.

`docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE wordpress; SHOW TABLES;"'`  
Permet de verifier que la base `wordpress` contient bien des tables.

`docker compose -f srcs/docker-compose.yml exec wordpress sh -lc 'wp user list --allow-root --path=/var/www/html/wordpress'`  
Permet de verifier que les utilisateurs WordPress ont bien ete crees.

`docker exec -it srcs-mariadb-1 sh`
Entrer dans le container Mariadb (SHOW DATABASES; USE wordpress; SHOW TABLES; SELECT ID, user_login, user_email FROM wp_users;)

`make`  
Construit et lance tout le projet.

`make down`  
Arrete les conteneurs du projet.

`make re`  
Relance le projet en reconstruisant les images.

`make fclean`  
Arrete le projet, supprime les volumes Compose et nettoie les ressources Docker inutilisees.

`make dataclean`  
Fait un nettoyage complet du projet et vide aussi les dossiers `/home/jpaulis/data/...`.
