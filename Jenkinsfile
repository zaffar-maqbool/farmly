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

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Stop Current Container') {
            steps {
                script {
                    // Stop and remove the current container
                    sh """
                        docker ps -q --filter label=${CURRENT_CONTAINER_LABEL} | xargs --no-run-if-empty docker stop
                        docker ps -a -q --filter label=${CURRENT_CONTAINER_LABEL} | xargs --no-run-if-empty docker rm
                    """
                }
            }
        }

        stage('Deploy New Container') {
            steps {
                script {
                    // Start the new container with the final label
                    sh """
                        docker run -d -p ${FINAL_PORT}:80 --label ${CURRENT_CONTAINER_LABEL} ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up any containers with the old label
            script {
                sh """
                    docker ps -a -q --filter label=${OLD_CONTAINER_LABEL} | xargs --no-run-if-empty docker stop
                    docker ps -a -q --filter label=${OLD_CONTAINER_LABEL} | xargs --no-run-if-empty docker rm
                """
            }
        }
    }
}
