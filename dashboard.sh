#!/bin/bash
mkdir dashboard-setup
cd dashboard-setup/
mkdir certs
cd certs/
mkdir ca openssl
cd openssl/
cd ..
openssl genrsa -out CA.key 2048
mv CA.key ca/
cd ca/
openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024 -out CA.pem
cd ../ 
mkdir server
cd server
openssl genrsa -out privatekey.key 2048
openssl req -new -key privatekey.key -out CSR.csr
openssl x509 -req -in CSR.csr -CA ../ca/CA.pem -CAkey ../ca/CA.key -CAcreateserial -out cert.pem -days 365
cd ..
cd openssl/
cp -rp ../ca/CA.pem .
cp -rp ../ca/CA.key .
mv CA.key ca_key.pem
mv CA.pem ca_crt.pem
## cd ../../../ (2 files should be there openssl.cnf , regenrate_certs.sh and eedit the files based on domain name in both files)
cat ../../../openssl.cnf >> openssl.cnf
cat ../../../regenrate_certs.sh >> regenrate_certs.sh
bash regenrate_certs.sh
mkdir dashboard
cp -rp privatekey.key dashboard/dashboard.key
cp -rp kubernetes-*.*.com-onlycert.pem dashboard/dashboard.crt
cd dashboard/
openssl x509 -in dashboard.crt -text -noout
kubectl create secret generic kubernetes-dashboard-certs --from-file=/root/dashboard-setup/certs/openssl/dashboard -n kube-system
cd ../../../
cat ../kubernetes-dashboard-clusterrolebinding.yaml >> kubernetes-dashboard-clusterrolebinding.yaml
cat ../kubernetes-dashboard-ingress.yaml >> kubernetes-dashboard-ingress.yaml
cat ../kubernetes-dashboard.yaml >> kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard-ingress.yaml
kubectl apply -f kubernetes-dashboard-clusterrolebinding.yaml 
kubectl apply -f kubernetes-dashboard.yaml
