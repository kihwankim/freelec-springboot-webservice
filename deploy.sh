#!/bin/bash

REPOSITORY=/home/ec2-user/app/step1
PROJECT_NAME=freelec-springboot-webservice

cd $REPOSITORY/$PROJECT_NAME/

echo "> Git Pull"

git pull

echo "> 프로젝트 build 시작"

chmod +x ./gredlew

./gredlew build

echo "> step1 디렉터리 이동"

cd $REPOSITORY

echo "> Build 파일 복사"

cp $REPOSITORY/$PROJECT_NAME/build/lib/*.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=${pgrep-f ${PROJECT_NAME}.*jar}

echo "현재 구동중인 애플리케이션 pid : $CURRENT_PID"

if [ -z "$CURRENT_PID"]; then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> 새 어플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

nohup java -jar \
  -Dspring.config.location=classpath:/application.yml,/home/ec2-user/app/application-oauth.yml,/home/ec2-user/app/application-real-db.yml \
  -Dspring.profiles.active=real \
  $REPOSITORY/$JAR_NAME 2>&1 &
