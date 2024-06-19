pipeline {
    agent any
    tools{
        jdk 'jdk17'
    }
    environment {
        COMPOSE_FILE = 'docker-compose.yml'
        SONARQUBE_CREDENTIALS = 'Sonar-token' // Update with your SonarQube credentials ID
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
}
