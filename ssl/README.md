# Generate .crt, .key files

```
$ openssl genrsa -out domain.key 2048

$ openssl ecparam -genkey -name secp384r1 -out domain.key

$ openssl req -new -x509 -sha256 -key domain.key -out domain.crt -days 3650
```