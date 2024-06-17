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

        stage('Build and Deploy with Docker Compose') {
            steps {
                script {
                    // Deploy using docker-compose
                    sh "docker-compose -f $COMPOSE_FILE up -d"
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