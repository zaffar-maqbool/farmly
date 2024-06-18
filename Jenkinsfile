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
        always {
            script {
                slackSend (channel: '#your-channel', color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        success {
            script {
                slackSend (channel: '#your-channel', color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        failure {
            script {
                slackSend (channel: '#your-channel', color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
    }
}
