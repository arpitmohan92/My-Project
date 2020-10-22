echo "*** Tranfer enviornment variables ***"
echo $IMAGE > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
scp -i /opt/dev /tmp/.auth ec2-user@172.31.34.237:/tmp/ 

echo "*** Tranfer the support sctipt to remote server ***"
scp -i /opt/dev publish ec2-user@172.31.34.237:/tmp/

echo "*** Logging into remote machine ***"
ssh -i /opt/dev ec2-user@172.31.34.237 "/tmp/publish" 

