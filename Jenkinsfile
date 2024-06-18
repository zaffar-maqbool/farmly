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

    stage('Run SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: "${SONARQUBE_CREDENTIALS}", variable: 'SONAR_TOKEN')]) {
          script {
            // Leverage withSonarQubeEnv for scanner configuration
            withSonarQubeEnv(serverId: 'SonarQubeScanner') {
              scanner.projectKey = "your_project_key" // Set project key
              scanner.sources = "." // Set source directory
              sh "sonar-scanner" // Run scanner with pre-defined options
            }
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
