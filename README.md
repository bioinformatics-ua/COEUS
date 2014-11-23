COEUS: Semantic Web Application Framework
=========================================

Ipsa scientia potestas est. Knowledge itself is power.
Next-generation Semantic Web Application Framework.

To get started -- visit http://bioinformatics.ua.pt/coeus/


How to deploy?
========================


1. Install dependencies: mysql-server and tomcat7. 

This is an example for running default instance: 
```
$ mysql -u root -p 
CREATE DATABASE coeus;
CREATE USER 'demo'@'localhost' IDENTIFIED BY 'demo';
-- Take care with the following line, it gives permissions for staff
GRANT ALL PRIVILEGES ON demo . * TO 'demo'@'localhost';
FLUSH PRIVILEGES;


```

2. Deploy coeus war file in the tomcat. You should deploy for instance in /coeus.
3. Go to the hostname and port where the tomcat is deployed. For instance, http://127.0.0.1:8080/coeus/
