pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_ENV = 'http://3.86.237.201:9000'  // Update with your SonarQube server name in Jenkins configuration
        SLACK_CREDENTIALS = 'slackwebhook'  // Update with your Slack credential ID
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

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') { // SonarQube server name in Jenkins configuration
                        // Run SonarQube Scanner
                        sh 'sonar-scanner -Dsonar.projectKey=your_project_key -Dsonar.sources=src -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    // Wait for SonarQube analysis to be completed and check Quality Gate status
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
                slackSend (color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        success {
            script {
                slackSend (color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        failure {
            script {
                slackSend (color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
    }
}
