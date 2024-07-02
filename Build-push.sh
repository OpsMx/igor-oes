# To Know Git version
git --version

# To Know Docker version
docker --version

# To Run Gradale Build need to have Java Vesion 1.17.+
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Setting JAVA_HOME to System PATH
export PATH=$PATH:$JAVA_HOME

# Get the Shorter format of Git-SHA 
export GITHASH=`git rev-parse --short HEAD`

# Get the BUILD Date
export BUILDDATE=`date -u +"%Y%m%d%H%M"`

# For Assiging the Gradle Resources
export GRADLE_OPTS="-Xmx6g -Xms6g"
export SERVICE_NAME="ubi8-spin-igor"
export QUAY_REPO_NAME="quay.io/opsmxpublic"
export DOCKER_REPO_NAME="opsmx11"

# The Current Build ID 
echo "Build id is --------------------- $BUILD_ID"

# Gradle command  to Produce the Dependant targetfiles for Docker build
./gradlew --no-daemon igor-web:installDist -x test

   # Assigning Rhel Image Name according to Quay.io Details
   IMAGENAME="${QUAY_REPO_NAME}/${SERVICE_NAME}:${GITHASH}-${BUILD_NUMBER}"
   
   # Assigning Rhel Image Name according to Docker.io Details
   RELEASE_IMAGENAME="${DOCKER_REPO_NAME}/${SERVICE_NAME}:${GITHASH}-${BUILD_NUMBER}"  
   
   # To Build Docker image with Given Docker File
   docker build -t $IMAGENAME -t $RELEASE_IMAGENAME .  -f  ${DOCKERFILE_PATH} --no-cache 
   
   # Quay.io login
   docker login -u $quay_user -p $quay_pass quay.io
   
   # To Push the Docker image into Quay.io
   docker push $IMAGENAME

   # Docker.io login
   docker login -u $docker_user -p $docker_pass docker.io
   
   # To Push the Docker image into Docker.io
   docker push $RELEASE_IMAGENAME
   
   echo "image=${IMAGENAME}" 

# Quay Image Name as Artifact
#echo \"Igor\": \"${IMAGENAME}\" > file.properties;
echo "image=${IMAGENAME}" > spinnakerfile.properties
