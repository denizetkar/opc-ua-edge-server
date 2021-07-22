#!/bin/bash


if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi
if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

rm -rf ./certificates/opcua ./certificates/iiot || exit 1
sudo -u $real_user mkdir -p ./certificates/opcua && cd ./certificates/opcua || exit 1
sudo -u $real_user docker cp opc-ua-edge-server:/root/.config/node-opcua-default-nodejs/PKI/own/certs/. . || exit 1
sudo -u $real_user openssl x509 -inform PEM -outform DER -text -in certificate.pem -out opcua_cert.der || exit 1
cp -f opcua_cert.der /mount/pki/trusted/certs || exit 1
chown root:root /mount/pki/trusted/certs/opcua_cert.der || exit 1

cd .. && sudo -u $real_user mkdir -p ./iiot && cd iiot || exit 1
cp -r /mount/pki/own/certs/. . || exit 1
chown -R $real_user:$real_user . || exit 1
for f in *.der; do
    sudo -u $real_user openssl x509 -inform DER -outform PEM -text -in "${f}" -out "${f}.pem" || exit 1
    sudo -u $real_user rm -f "${f}" || exit 1
done
sudo -u $real_user docker cp . opc-ua-edge-server:/root/.config/node-opcua-default-nodejs/PKI/trusted/certs || exit 1
# sudo -u $real_user docker exec opc-ua-edge-server chown -R root:root /root/.config/node-opcua-default-nodejs/PKI/trusted/certs || exit 1
