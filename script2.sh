aws ssm create-document --name "YourDocumentName" --document-type "Command" --content file://path/to/your/script.json

aws ssm send-command --document-name "YourDocumentName" --targets "Key=instanceids,Values=your-instance-id" --parameters commands="your-script-commands"


{
  "schemaVersion": "2.2",
  "description": "Install Apache Tomcat on Linux",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "installTomcat",
      "inputs": [
        "#!/bin/bash",
        "sudo yum update -y",
        "sudo yum install -y java-1.8.0-openjdk",
        "sudo groupadd tomcat",
        "sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat",
        "wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M1/bin/apache-tomcat-9.0.0.M1.tar.gz -P /tmp",
        "sudo tar xf /tmp/apache-tomcat-9.0.0.M1.tar.gz -C /opt/tomcat",
        "sudo ln -s /opt/tomcat/apache-tomcat-9.0.0.M1 /opt/tomcat/latest",
        "sudo chown -R tomcat: /opt/tomcat/latest",
        "sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'",
        "sudo sh -c 'chmod 755 /opt/tomcat/latest/conf'",
        "sudo firewall-cmd --permanent --add-port=8080/tcp",
        "sudo firewall-cmd --reload",
        "sudo systemctl start tomcat",
        "sudo systemctl enable tomcat"
      ]
    }
  ]
}
