#!/bin/bash



# Muutujad

WEBAPP_DIR="/opt/webapp"

IMAGE_NAME="minu-veeb"

CONTAINER_NAME="webapp"

PORT="8080"

REPO_URL="https://github.com/korneff1337/devops_projekt.git"



# Mine rakenduse kausta

cd $WEBAPP_DIR || exit 1



# Kontrolli, kas git repo on juba kloonitud

if [ -d ".git" ]; then

    echo "Tõmban uusima koodi..."
    
    git pull
    
else

    echo "Kloonin repositooriumi..."
    
    git clone $REPO_URL temp_repo
    
    mv temp_repo/* temp_repo/.* . 2>/dev/null
    
    rm -rf temp_repo
    
fi



# Ehita uus Dockeri pilt

echo "Ehitame uut Dockeri pilti..."

docker build -t $IMAGE_NAME .



# Peata ja kustuta vana konteiner, kui see eksisteerib

if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then

    echo "Peatan ja kustutan vana konteineri..."
    
    docker stop $CONTAINER_NAME
    
    docker rm $CONTAINER_NAME
    
fi



# Käivita uus konteiner

echo "Käivitan uue konteineri..."

docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME



echo "Deploy edukalt lõpetatud!"










