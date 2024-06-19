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

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: SONARQUBE_CREDENTIALS
                }
            }
        }
    }
    post {
        always {
            // Define Slack message components
            def pipelineStatus = currentBuild.currentResult ?: 'UNKNOWN'
            def jobName = env.JOB_NAME ?: 'Unknown Job'
            def buildNumber = env.BUILD_NUMBER ?: 'Unknown'
            def buildUrl = env.BUILD_URL ?: 'Build URL not available'
    
            // Define Slack message content
            def slackMessage = """
                *Pipeline Status*: ${pipelineStatus}
                *Job Name*: ${jobName}
                *Build Number*: ${buildNumber}
                *Build URL*: ${buildUrl}
            """
    
            // Send Slack notification after every build
            slackSend(
                channel: '#devops', // Specify your Slack channel
                color: getColorForStatus(pipelineStatus), // Use function to determine color based on status
                message: slackMessage.trim(), // Trim whitespace from the message
                tokenCredentialId: 'slack-jenkins-ci' // Use your credential ID for Slack integration
            )
        }
    }

    // Function to determine Slack color based on build status
    def getColorForStatus(String status) {
        switch (status) {
            case 'SUCCESS':
                return 'good' // Green color for success
            case 'FAILURE':
                return 'danger' // Red color for failure
            case 'ABORTED':
                return 'warning' // Yellow color for aborted
            default:
                return '#439FE0' // Blue color for unknown or other statuses
        }
    }

}
