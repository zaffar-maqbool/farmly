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
            //Add channel name
            slackSend channel: 'devops',
            message: "Find Status of Pipeline:- ${currentBuild.currentResult} ${env.JOB_NAME} ${env.BUILD_NUMBER} ${BUILD_URL}"
        }
    }
}

