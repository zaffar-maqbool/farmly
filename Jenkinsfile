pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
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
                    sh "docker-compose -f $COMPOSE_FILE up -d --build"
                }
            }
        }
    }
    post {
        always {
            script {
                slackSend (color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}")
            }
        }
        success {
            script {
                slackSend (color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.")
            }
        }
        failure {
            script {
                slackSend (color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.")
            }
        }
    }
}
}
