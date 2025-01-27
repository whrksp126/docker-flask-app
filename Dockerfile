# 베이스 이미지로 우분투 사용
FROM ubuntu:20.04

# 필수 패키지 설치 및 시간대 설정
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y python3-pip python3-dev nginx tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사 및 패키지 설치
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Flask 애플리케이션 복사
COPY app.py .

# 소켓 파일 생성 전 확인 및 삭제
RUN rm -rf /app/prod.sock

# CMD 명령: SOCKET_NAME 환경 변수를 사용하여 Gunicorn 실행
CMD ["sh", "-c", "rm -f /app/prod.sock && gunicorn --workers 3 --bind unix:/app/prod.sock app:app"]
