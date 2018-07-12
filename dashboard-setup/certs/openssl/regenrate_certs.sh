#!/bin/bash
#Script to generate TLS based server certificates for haproxy.


sitename=${1:-kubernetes-dashboard.vw.com}

cpath=$(pwd)

if [ -z "$sitename" ];then
echo -e "Usage : $0 <Target Server FQDN for Certificate>"
exit
fi

# Certificate Details
COUNTRY="US"                                     # 2 letter country-code
STATE="TX"                                    # state or province name
LOCALITY="Frisco"                                # Locality Name (e.g. city)
ORGNAME="Hindsight"                 # Organization Name (eg, company)
ORGUNIT="IT"   # Organizational Unit Name (eg. section)
EMAIL="ksrinii89@gmail.com"               # certificate's email address
SITE=$(echo $sitename)
PASS="Password400"
CERTDIR="$(echo $cpath)"

# Optional Extra Details
CHALLENGE=""                                     # challenge password
COMPANY=""                                       # company name

DAYS="-days 3650"                                # validity of cert

mkdir -p $CERTDIR
cd $CERTDIR
chmod 700 $CERTDIR
echo 1000 > serial
touch index.txt

echo -e "\nServer Certs will be generated in $CERTDIR\n"

if [ ! -f "$CERTDIR/privatekey.key" ];then
openssl genrsa -out privatekey.key 2048
fi

if [ ! -f "$CERTDIR/${sitename}.csr" ];then
echo -e "\nGenerating and Self Sign a new server key/cert pair\n"
cd $CERTDIR

cat <<__EOF__ | openssl req -new -key privatekey.key -sha256 -out ${sitename}.csr
$COUNTRY
$STATE
$LOCALITY
$ORGNAME
$ORGUNIT
$SITE
$EMAIL
$CHALLENGE
$COMPANY
__EOF__

cat <<__EOF__ | openssl x509 -req -in ${sitename}.csr -CA ca_crt.pem -CAkey ca_key.pem -CAcreateserial -out ${sitename}.pem -sha256 -days 3650 -extfile openssl.cnf
y
y
__EOF__

cp -rp ${sitename}.pem ${sitename}-onlycert.pem
cat ca_crt.pem privatekey.key >> ${sitename}.pem
openssl dhparam -out ${sitename}-dhparam.pem 2048

openssl x509 -in ${sitename}.pem -text -noout
echo -e "\nSuccessfully Generated the $CERTDIR/privatekey.key $CERTDIR/${sitename}.pem ..\n" | tee /var/log/gen_tls.log
else
openssl x509 -in ${sitename}.pem -text -noout
echo -e "\n$CERTDIR/privatekey.key and ${sitename}.pem already exist..\n"
fi
#!/bin/bash
#Script to generate TLS based server certificates for haproxy.


sitename=${1:-kubernetes-dashboard.vw.com}

cpath=$(pwd)

if [ -z "$sitename" ];then
echo -e "Usage : $0 <Target Server FQDN for Certificate>"
exit
fi

# Certificate Details
COUNTRY="US"                                     # 2 letter country-code
STATE="TX"                                    # state or province name
LOCALITY="Frisco"                                # Locality Name (e.g. city)
ORGNAME="Hindsight"                 # Organization Name (eg, company)
ORGUNIT="IT"   # Organizational Unit Name (eg. section)
EMAIL="ksrinii89@gmail.com"               # certificate's email address
SITE=$(echo $sitename)
PASS="Password400"
CERTDIR="$(echo $cpath)"

# Optional Extra Details
CHALLENGE=""                                     # challenge password
COMPANY=""                                       # company name

DAYS="-days 3650"                                # validity of cert

mkdir -p $CERTDIR
cd $CERTDIR
chmod 700 $CERTDIR
echo 1000 > serial
touch index.txt

echo -e "\nServer Certs will be generated in $CERTDIR\n"

if [ ! -f "$CERTDIR/privatekey.key" ];then
openssl genrsa -out privatekey.key 2048
fi

if [ ! -f "$CERTDIR/${sitename}.csr" ];then
echo -e "\nGenerating and Self Sign a new server key/cert pair\n"
cd $CERTDIR

cat <<__EOF__ | openssl req -new -key privatekey.key -sha256 -out ${sitename}.csr
$COUNTRY
$STATE
$LOCALITY
$ORGNAME
$ORGUNIT
$SITE
$EMAIL
$CHALLENGE
$COMPANY
__EOF__

cat <<__EOF__ | openssl x509 -req -in ${sitename}.csr -CA ca_crt.pem -CAkey ca_key.pem -CAcreateserial -out ${sitename}.pem -sha256 -days 3650 -extfile openssl.cnf
y
y
__EOF__

cp -rp ${sitename}.pem ${sitename}-onlycert.pem
cat ca_crt.pem privatekey.key >> ${sitename}.pem
openssl dhparam -out ${sitename}-dhparam.pem 2048

openssl x509 -in ${sitename}.pem -text -noout
echo -e "\nSuccessfully Generated the $CERTDIR/privatekey.key $CERTDIR/${sitename}.pem ..\n" | tee /var/log/gen_tls.log
else
openssl x509 -in ${sitename}.pem -text -noout
echo -e "\n$CERTDIR/privatekey.key and ${sitename}.pem already exist..\n"
fi
