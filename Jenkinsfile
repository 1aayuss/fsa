pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = '1aayuss/fsa'
        DOCKER_HUB_CREDENTIALS = 'dockerhub'
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        def app = docker.image("${DOCKER_HUB_REPO}:latest")
                        app.push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
