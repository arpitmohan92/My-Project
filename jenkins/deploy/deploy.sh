echo "*** Tranfer enviornment variables ***"
echo """" > /tmp/.auth
echo $IMAGE > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
sudo scp -i /opt/dev /tmp/.auth ec2-user@172.31.34.237:/tmp/ && \

echo "*** Tranfer the support sctipt to remote server ***"
sudo scp -i /opt/dev publish ec2-user@172.31.34.237:/tmp/

echo "*** Logging into remote machine ***"
sudo ssh -i /opt/dev ec2-user@172.31.34.237 "/tmp/publish" 

