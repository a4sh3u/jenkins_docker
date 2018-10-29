#!/usr/bin/env bash
mkdir jenkins_home || true; sudo chown -R 1000:1000 jenkins_home || true
docker run -d -p 8080:8080 -v `pwd`/jenkins_home:/var/jenkins_home/:rw -v /etc/localtime:/etc/localhost -v `pwd`/plugins.txt:/usr/share/jenkins/ref/plugins.txt --name myjenkins --env JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false" jenkins/jenkins
docker exec -ti myjenkins bash -c '/usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt'
docker restart myjenkins
echo
echo "Jenkins is running at http://localhost:8080"
