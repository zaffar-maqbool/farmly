pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker-compose.yml'
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

        stage('SonarQube Code Analysis') {
            steps {
                dir("${WORKSPACE}") {
                    script {
                        def scannerHome = tool name: 'scanner-name', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        withSonarQubeEnv('sonar') {
                            sh "${scannerHome}/bin/sonar-scanner \
                                -D sonar.projectVersion=1.0-SNAPSHOT \
                                -D sonar.projectKey=webapp-sample \
                                -D sonar.sources=. \
                                -D sonar.language=web \
                                -D sonar.sourceEncoding=UTF-8 \
                                -D sonar.host.url=http://3.85.165.27:9000 \
                                -D sonar.login=${env.SONAR_TOKEN}"
                        }
                    }
                }
            }
        }

        stage("SonarQube Quality Gate Check") {
            steps {
                script {
                    def qualityGate = waitForQualityGate()

                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed: ${qualityGate.status}"
                    } else {
                        echo "SonarQube Quality Gates Passed"
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
