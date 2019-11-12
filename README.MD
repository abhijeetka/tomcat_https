How to run this dockerfile


docker build -t tomcat_https .

docker run -d -p 8080:8080 -p 8443:8443 -e ADMIN_PASS='1234567' -e CERT_PASS='987654' tomcat_new
