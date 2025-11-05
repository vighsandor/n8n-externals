openssl s_client -showcerts -connect pki.codegic.com:443 </dev/null 2>/dev/null | \
  sed -n '/BEGIN CERTIFICATE/,/END CERTIFICATE/p' > /tmp/pki_codegic_chain.pem

if [ ! -s /tmp/pki_codegic_chain.pem ]; then
  echo "ERROR: Failed to download certificate!"
  exit 1
fi

mkdir -p /usr/local/share/ca-certificates
cp /tmp/pki_codegic_chain.pem /usr/local/share/ca-certificates/codegic.crt
update-ca-certificates
JAVA_CACERTS=$(find /usr -name cacerts 2>/dev/null | grep -E 'java|jre|jdk' | head -1)

if [ -z "$JAVA_CACERTS" ]; then
  JAVA_CACERTS="/usr/lib/jvm/default-jvm/jre/lib/security/cacerts"
fi
keytool -delete -alias codegic_root -keystore "$JAVA_CACERTS" -storepass changeit -noprompt 2>/dev/null || true
keytool -import -trustcacerts -alias codegic_root \
  -file /tmp/pki_codegic_chain.pem \
  -keystore "$JAVA_CACERTS" \
  -storepass changeit -noprompt

curl https://pki.codegic.com/crls/CodegicCA.crl -o /tmp/CodegicCA.crl
