COEUS: Semantic Web Application Framework
=========================================

Ipsa scientia potestas est. Knowledge itself is power.
Next-generation Semantic Web Application Framework.

To get started -- visit http://bioinformatics.ua.pt/coeus/


How to deploy?
========================


1. Install [MySQL Server](http://dev.mysql.com/downloads/mysql/): 


  Note: root access or other user with similar permissions (CREATE DATABASE, TABLES,..) is required.
  
  To create a user 'demo' to test:
  ```
  $ mysql -u root -p 
  CREATE USER 'demo'@'localhost' IDENTIFIED BY 'demo';
  -- Take care with the following line, it gives permissions for staff
  GRANT ALL PRIVILEGES ON demo . * TO 'demo'@'localhost';
  FLUSH PRIVILEGES;
  ```
  
  If you need other database please visit the list of [databases supported](http://jena.apache.org/documentation/sdb/databases_supported.html) (not implemented yet).
 
2. Install [Apache Tomcat 7](http://tomcat.apache.org/download-70.cgi):  

  Note: It requires the manager web application, installed by default on context path "/manager". To enable access you must either add a username/password combination to your [tomcat-users.xml](http://tomcat.apache.org/tomcat-7.0-doc/realm-howto.html#UserDatabaseRealm) file on the Tomcat application server: 
    ```
  <user name="your_name" password="your_password" roles="manager-gui,manager-script" />
    ```
  It is also recommended that you check the write permissions of the tomcat webapps folder.

3. Deploy coeus war file in the tomcat. You should deploy for instance in /coeus.
4. Go to the hostname and port where the tomcat is deployed. For instance, http://127.0.0.1:8080/coeus/

For more information please visit: [COEUS Documentation](http://bioinformatics.ua.pt/coeus/documentation/)





