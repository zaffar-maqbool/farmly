pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "zaffarwani/farmly:v1"
        NEW_CONTAINER_LABEL = "new_farmly_container"
        CURRENT_CONTAINER_LABEL = "current_farmly_container"
        OLD_CONTAINER_LABEL = "old_farmly_container"
        FINAL_PORT = "80"
    }

    stages {
        stage('Verify Docker Access') {
            steps {
                script {
                    sh 'docker ps'
                }
            }
        }

        stage('Run Tests') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        // Build and run the test Docker container
                        sh """
                            docker build -t farmly-test -f Dockerfile.test .
                            docker run --rm farmly-test
                        """
                    }
                }
            }
        }

        stage('Build and Deploy with Docker Compose') {
            steps {
                script {
                    // Stop and remove old containers
                    sh """
                        docker-compose down || true
                    """

                    // Build and start the containers using Docker Compose
                    sh """
                        docker-compose up -d --build
                    """
                }
            }
        }

        stage('Scale Services') {
            steps {
                script {
                    // Scale the web service to 3 instances
                    sh """
                        docker-compose up -d --scale web=3
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up any stopped containers
            script {
                sh """
                    docker-compose down --remove-orphans || true
                """
            }
        }
    }
}
