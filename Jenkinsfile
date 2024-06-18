pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SLACK_CREDENTIALS = 'slack-jenkins-ci'  // Update with your Slack credential ID
        SONARQUBE_SCANNER_HOME = tool 'SonarQubeScanner'  // Assuming SonarQube Scanner tool is configured in Jenkins
        SONARQUBE_SERVER_URL = 'http://3.85.165.27:9000'  // Update with your SonarQube server URL
        SONARQUBE_CREDENTIALS = credentials('sonaq-jenkins')  // Update with your SonarQube credentials ID
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

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    // Run SonarQube scanner
                    sh "${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=my_project_key \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=${SONARQUBE_SERVER_URL} \
                        -Dsonar.login=${SONARQUBE_CREDENTIALS}"
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
                color: currentBuild.currentResult == 'SUCCESS' ? '#00FF00' : '#FF0000',
                message: "Find Status of Pipeline: ${currentBuild.currentResult} ${env.JOB_NAME} ${env.BUILD_NUMBER} ${BUILD_URL}",
                tokenCredentialId: 'slack-jenkins-ci'
            )
        }
    }
}
