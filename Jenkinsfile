pipeline {
    agent {
        docker {
            image 'your_jenkins_agent_image_with_docker' // Replace with your Jenkins agent image that has Docker
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
    }

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_CONTAINER = '520439cf7098'  // Replace with your SonarQube container name or ID
        SONARQUBE_URL = "http://${SONARQUBE_CONTAINER}:9000"  // Assuming SonarQube runs on port 9000 inside the container
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
                    // Run SonarQube scanner from Jenkins agent
                    docker.image('your_sonarqube_scanner_image')
                        .inside("--network=host") {  // Use host network mode to access SonarQube container
                            sh "sonar-scanner -Dsonar.projectKey=your_project_key -Dsonar.sources=src -Dsonar.host.url=${SONARQUBE_URL} -Dsonar.login=your_sonarqube_token"
                        }
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
                slackSend(color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        success {
            script {
                slackSend(color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
        failure {
            script {
                slackSend(color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.", tokenCredentialId: env.SLACK_CREDENTIALS)
            }
        }
    }
}
