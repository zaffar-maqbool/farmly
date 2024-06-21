pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
    }
    
    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_CREDENTIALS = credentials('Sonar-token') // Update with your SonarQube credentials ID
        SCANNER_HOME = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        APP_NAME = "2b5d451a17c5"
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
        
        stage('Scan Docker Image') {
            steps {
                script {
                    // Run Trivy to scan the Docker image
                    def trivyOutput = sh(script: "trivy image ${APP_NAME}:latest", returnStdout: true).trim()

                    // Display Trivy scan results
                    echo trivyOutput

                    // Check if vulnerabilities were found
                    if (trivyOutput.contains("Total: 0")) {
                        echo "No vulnerabilities found in the Docker image."
                    } else {
                        echo "Vulnerabilities found in the Docker image."
                        // You can take further actions here based on your requirements
                        // For example, failing the build if vulnerabilities are found
                        // error "Vulnerabilities found in the Docker image."
                    }
                }
            }
        }
        
        stage('Build and Deploy with Docker Compose') {
            steps {
                script {
                    // Deploy using docker-compose
                    sh "docker-compose -f ${COMPOSE_FILE} up -d --build --remove-orphans"
                }
            }
        }

        stage("Sonarqube Analysis") {
            steps {
                // Run SonarQube analysis using configured scanner tool
                withSonarQubeEnv('sonar-server') {
                    sh """${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectName='farmy' \
                        -Dsonar.projectKey='farmy' \
                        -Dsonar.sources='.' \
                        -Dsonar.login='${SONARQUBE_CREDENTIALS}'""" // Add additional analysis parameters as needed
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
                message: "Pipeline Status: ${currentBuild.currentResult} ${env.JOB_NAME} ${env.BUILD_NUMBER} ${BUILD_URL}",
                tokenCredentialId: 'slack-webhook'
            )
        }
    }
}
