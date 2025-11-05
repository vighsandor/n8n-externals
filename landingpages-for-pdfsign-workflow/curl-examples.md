## Example Sign With CURL
**Without Visible Stamp**
```
#!/bin/bash

time=$(date '+%Y%m%d_%H%M%S')

# Signing Certificate Params
##  -F "pfxFile=@certificate.pfx" \
##  -F "pfxPassword=abcd1234" \

curl -X POST "http://192.168.1.100:5678/webhook/pdf-sign" \
  -F "pdfFile=@testpdf.pdf" \
  -F "pfxFile=@testcert.pfx" \
  -F "pfxPassword=12345678" \
  -F "signLevel=T" \
  -o signed_output_$time.pdf

# SignLevels
##  -F "signLevel=B" \
##  -F "signLevel=T" \
##  -F "signLevel=LT" \
##  -F "signLevel=LTA" \

echo "Signed PDF saved: signed_output_$time.pdf"
```

**With Visible Stamp**
```
#!/bin/bash

time=$(date '+%Y%m%d_%H%M%S')

# Signing Certificate Params
##  -F "pfxFile=@certificate.pfx" \
##  -F "pfxPassword=abcd1234" \

# Visible Stamp Params
##  -F "isVisible=true" \
##  -F "logoFile=@signlogo.jpg" \

curl -X POST "http://192.168.1.100:5678/webhook/pdf-sign" \
  -F "pdfFile=@testpdf.pdf" \
  -F "pfxFile=@testcert.pfx" \
  -F "pfxPassword=12345678" \
  -F "signLevel=T" \
  -F "isVisible=true" \
  -F "logoFile=@testsignlogo.jpg" \
  -o signed_output_$time.pdf

# SignLevels
##  -F "signLevel=B" \
##  -F "signLevel=T" \
##  -F "signLevel=LT" \
##  -F "signLevel=LTA" \

echo "Signed PDF saved: signed_output_$time.pdf"
```
