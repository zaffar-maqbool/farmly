pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SLACK_CREDENTIALS = 'slack-jenkins-ci'
        SONARQUBE_CREDENTIALS = 'sonaq-jenkins' // Update with your SonarQube credentials ID
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

        stage('Run SonarQube Analysis') {
            environment {
                scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            }
            steps {
                withCredentials([string(credentialsId: "${SONARQUBE_CREDENTIALS}", variable: 'SONAR_TOKEN')]) {
                    script {
                        def scannerCmd = """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.host.url=http://3.85.165.27:9000 \
                            -Dsonar.login=${env.SONAR_TOKEN} \
                            -Dsonar.projectKey=your_project_key \
                            -Dsonar.sources=.
                        """
                        sh scannerCmd.trim()
                    }
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
                tokenCredentialId: 'slack-jenkins-ci'
            )
        }
    }
}
