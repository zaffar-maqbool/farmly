pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SLACK_CREDENTIALS = 'slack-webhook'  // Update with your credential ID
    }

    stages {
        stage('Verify Docker Access') {
            steps {
                script {
                    // Verify Docker access
                    sh 'docker ps'
                }
            }
        }

        stage('Build and Deploy with Docker Compose') {
            steps {
                script {
                    // Deploy using docker-compose
                    sh "docker-compose -f $COMPOSE_FILE up -d --build --remove-orphans"
                }
            }
        }
    }

    post {
        success {
            slackSend(channel: '#your-channel', color: '#00FF00', message: "Build successful", tokenCredentialId: 'slack-webhook')
        }
        failure {
            slackSend(channel: '#your-channel', color: '#FF0000', message: "Build failed", tokenCredentialId: 'slack-webhook')
        }
    }
}
}
