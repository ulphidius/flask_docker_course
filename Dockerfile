FROM python:3.8
ENV FLASK_ENV=development
WORKDIR /app
COPY . .
EXPOSE 5000
RUN ["python", "setup.py", "install"]
CMD ["python", "-m", "flask_docker_course"]
