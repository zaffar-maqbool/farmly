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
                script {
                    // Build and run the test Docker container
                    sh """
                        docker build -t farmly-test -f Dockerfile.test .
                        docker run --rm farmly-test
                        docker run --rm farmly-test || true
                    """
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
