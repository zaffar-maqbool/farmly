pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_ENV = 'http://3.86.237.201:9000'  // Update with your SonarQube server URL
        SLACK_CREDENTIALS = 'slackwebhook'  // Update with your Slack credential ID
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
                    sh "docker-compose -f $COMPOSE_FILE up -d --build"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Use single quotes for docker run command to avoid Groovy variable substitution
                    sh 'docker run --rm ' +
                       "-e SONAR_HOST_URL=$SONARQUBE_ENV " +
                       '-v $(pwd):/usr/src ' +
                       'sonarsource/sonar-scanner-cli'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                slackSend(color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}", tokenCredentialId: SLACK_CREDENTIALS)
            }
        }
        success {
            script {
                slackSend(color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.", tokenCredentialId: SLACK_CREDENTIALS)
            }
        }
        failure {
            script {
                slackSend(color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.", tokenCredentialId: SLACK_CREDENTIALS)
            }
        }
    }
}
