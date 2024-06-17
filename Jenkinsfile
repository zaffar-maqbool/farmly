pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_ENV = 'http://3.86.237.201:9000'  // Update with your SonarQube server URL
        SONAR_LOGIN = credentials('sonar-login')  // Use the credential ID for SonarQube authentication
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
                    // Run SonarQube scanner from within the Jenkins agent
                    sh "docker run --rm " +
                       "-e SONAR_HOST_URL=$SONARQUBE_ENV " +
                       "-e SONAR_LOGIN=${SONAR_LOGIN} " +  // Use the SONAR_LOGIN credential
                       "-v $(pwd):/usr/src " +
                       "sonarsource/sonar-scanner-cli"
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

    // Optionally, you can add a post section for Slack notifications here if needed

    // post {
    //     always {
    //         script {
    //             slackSend(color: '#FFFF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' finished with status: ${currentBuild.currentResult}", tokenCredentialId: SLACK_CREDENTIALS)
    //         }
    //     }
    //     success {
    //         script {
    //             slackSend(color: '#00FF00', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.", tokenCredentialId: SLACK_CREDENTIALS)
    //         }
    //     }
    //     failure {
    //         script {
    //             slackSend(color: '#FF0000', message: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.", tokenCredentialId: SLACK_CREDENTIALS)
    //         }
    //     }
    // }
}
