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

        stage('Deploy New Container with Label') {
            steps {
                script {
                    // Start the new container with a temporary label
                    sh """
                        docker run -d -p ${FINAL_PORT}:80 --label ${NEW_CONTAINER_LABEL} ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Switch Labels') {
            steps {
                script {
                    // Verify the new container is running
                    def newRunning = sh(script: "docker ps --filter label=${NEW_CONTAINER_LABEL} --format '{{.ID}}'", returnStdout: true).trim()

                    if (newRunning) {
                        // Stop and remove the current container
                        sh """
                            docker ps -q --filter label=${CURRENT_CONTAINER_LABEL} | xargs --no-run-if-empty docker stop
                            docker ps -a -q --filter label=${CURRENT_CONTAINER_LABEL} | xargs --no-run-if-empty docker rm
                        """

                        // Relabel the new container to current
                        sh """
                            docker ps -a -q --filter label=${NEW_CONTAINER_LABEL} | xargs --no-run-if-empty docker stop
                            docker ps -a -q --filter label=${NEW_CONTAINER_LABEL} | xargs --no-run-if-empty docker rm
                            docker run -d -p ${FINAL_PORT}:80 --label ${CURRENT_CONTAINER_LABEL} ${DOCKER_IMAGE}
                        """
                    } else {
                        error "New container failed to start"
                    }
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
