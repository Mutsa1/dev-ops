# Running a Secured Registry Container in Linux

http://training.play-with-docker.com/linux-registry-part2/

## Generating the SSL Certificate in Linux

```bash
mkdir -p certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key -x509 -days 365 -out certs/domain.crt

```