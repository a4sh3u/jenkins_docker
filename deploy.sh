#!/usr/bin/env bash

docker run -d -p 8080:8080 -v `pwd`/jobs:/var/jenkins_home/jobs/:rw -v /etc/localtime:/etc/localhost -v `pwd`/plugins.txt:/usr/share/jenkins/ref/plugins.txt --name myjenkins --env JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false" jenkins/jenkins
docker exec -ti myjenkins bash -c '/usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt'

echo "Jenkins is running at http://localhost:8080"
