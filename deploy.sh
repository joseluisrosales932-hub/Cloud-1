#!/bin/bash
SERVERS=("141.148.22.61:llave-web1.key" "129.80.3.128:llave-web2.key" "129.80.99.113:llave-web3.key")
DEST="/usr/share/nginx/html/agenda"
KEYDIR="$HOME/Downloads"

for S in "${SERVERS[@]}"; do
  IP="${S%%:*}"; KEY="$KEYDIR/${S##*:}"
  echo ">> Sincronizando con $IP"
  ssh -i "$KEY" -o StrictHostKeyChecking=no opc@$IP "rm -rf $DEST/*"
  scp -i "$KEY" -o StrictHostKeyChecking=no -r index.php agregar.php editar.php eliminar.php config.php css includes database opc@$IP:$DEST/
  ssh -i "$KEY" -o StrictHostKeyChecking=no opc@$IP "sudo chmod -R a+rX $DEST && sudo restorecon -R $DEST; sudo systemctl restart php-fpm nginx"
done

echo "Listo. Servidores disponibles:"
for S in "${SERVERS[@]}"; do echo "  http://${S%%:*}/agenda/"; done