pipeline {
    agent {
        dockerfile true
    }
    environment {
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout your code from your version control system
                    checkout scm
                }
            }
        }

        stage('Setup Virtual Environment') {
            steps {
                script {
                    // Set up a virtual environment and install dependencies
                    // sh 'python -m venv venv'
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run pytest
                    sh 'pytest'
                }
            }
        }

        stage('Send GitHub action') {
             when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                 script {
                    def url = "https://api.github.com/repos/sparkingdark/helloworld/actions/workflows/hello_world.yml/dispatches"
                    def payload = '{"ref":"main"}'  // JSON payload without the trailing comma

                    try {
                        def response = sh(
                            script: """
                                curl -L -X POST \
                                    -H 'Accept: application/vnd.github.v3+json' \
                                    -H 'Authorization: Bearer $GITHUB_TOKEN' \
                                    -H 'X-GitHub-Api-Version: 2022-11-28' \
                                    -d '$payload' $url
                            """,
                            returnStdout: true
                        ).trim()

                        echo "Response: $response"
                    } catch (Exception e) {
                        echo "Failed to invoke GitHub Actions Workflow: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

    }

    post {
        success {
            // This block is executed only if the pipeline is successful
            echo 'Pipeline successful!'
        }

        failure {
            // This block is executed only if the pipeline fails
            echo 'Pipeline failed! Sending GitHub comment...'
            // GitHub comment can be added here as well, or other notifications based on your needs
        }
    }
}