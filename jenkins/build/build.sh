cp java-app/webapp/target/*.war jenkins/build/

cd jenkins/build && docker-compose build

