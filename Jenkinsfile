pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
    }

    stages {
        stage('Verify Docker Access') {
            steps {
                script {
                    sh 'docker ps'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t zaffarwani/farmly:v1 .'
                }
            }
        }

        stage('Build and Deploy with Docker Compose') {
            steps {
                script {
                    // Pull the latest image and deploy using docker-compose
                    sh "docker-compose -f $COMPOSE_FILE pull"
                    sh "docker-compose -f $COMPOSE_FILE up -d --build"
                }
            }
        }
    }

    post {
        always {
            // Clean up unused resources if necessary
            script {
                sh "docker-compose -f $COMPOSE_FILE down --remove-orphans"
            }
        }
    }
}
