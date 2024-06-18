Fpipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SLACK_CREDENTIALS = 'slack-jenkins-ci'  // Update with your credential ID
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
            // Send Slack notification after every build
            slackSend(
                channel: '#devops',  // Replace with your Slack channel name
                color: '#FFFF00',  // Yellow color for the message
                message: "Find Status of Pipeline: ${currentBuild.currentResult} ${env.JOB_NAME} ${env.BUILD_NUMBER} ${BUILD_URL}",
                tokenCredentialId: 'slack-jenkins-ci'
            )
        }
    }
}
