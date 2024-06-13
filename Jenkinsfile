pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "zaffarwani/farmly:v1"
        OLD_CONTAINER = "farmly-container-old"
        NEW_CONTAINER = "farmly-container"
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

        stage('Deploy New Container') {
            steps {
                script {
                    // Check if old container is running
                    def oldRunning = sh(script: "docker ps --filter name=${NEW_CONTAINER} --format '{{.Names}}'", returnStdout: true).trim()
                    
                    if (oldRunning) {
                        // Rename old container
                        sh "docker rename ${NEW_CONTAINER} ${OLD_CONTAINER}"
                    }

                    // Start new container
                    sh "docker run -d -p 80:80 --name ${NEW_CONTAINER} ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Cleanup Old Container') {
            steps {
                script {
                    // Stop and remove the old container if it exists
                    def oldExists = sh(script: "docker ps -a --filter name=${OLD_CONTAINER} --format '{{.Names}}'", returnStdout: true).trim()
                    
                    if (oldExists) {
                        sh "docker stop ${OLD_CONTAINER}"
                        sh "docker rm ${OLD_CONTAINER}"
                    }
                }
            }
        }
    }
}
