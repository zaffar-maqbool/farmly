pipeline {
    agent any
    tools{
        jdk 'jdk17'
    }
    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_CREDENTIALS = 'Sonar-token' // Update with your SonarQube credentials ID
        SCANNER_HOME=tool 'sonar-scanner'
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
                    sh "docker-compose -f ${env.COMPOSE_FILE} up -d --build --remove-orphans"
                }
            }
        }

        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=farmy \
                    -Dsonar.projectKey=farmy '''
                }
            }
        }


    }
    post {
        always {
            // Send Slack notification after every build
            slackSend(
                channel: '#devops',
                color: '#FF0000',
                message: "Find Status of Pipeline: ${currentBuild.currentResult} ${env.JOB_NAME} ${env.BUILD_NUMBER} ${BUILD_URL}",
                tokenCredentialId: 'slack-webhook'
            )
        }
    }
}
