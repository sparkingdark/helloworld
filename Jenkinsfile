pipeline {
    agent {
        dockerfile true
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
            script {
                    try {
                        def url = "https://api.github.com/repos/sparkingdark/helloworld/actions/workflows/hello_world.yml/dispatches"
                        def response = sh(script: 'curl -X POST -H "Accept: application/vnd.github.v3+json" -H "authorization: Bearer $GH_TOKEN " -d \'{"ref":"main"}\' "${url}"', returnStdout: true).trim()
                        echo "Response: ${response}"
                    } catch (Exception e) {
                        echo "Failed to invoke GitHub Actions Workflow: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                    }
                }
        }

    //     stage('Send GitHub Comment') {
    //         when {
    //             expression { currentBuild.resultIsBetterOrEqualTo('FAILURE') }
    //         }
    //         steps {
    //             script {
    //                 // Send GitHub comment on pull request
    //                 sh 'curl -X POST -H "Authorization: Bearer $GH_TOKEN" -H "Accept: application/vnd.github.v3+json" -d \'{"body": "Tests failed! Please check the CI logs."}\' "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$CHANGE_ID/comments"'
    //             }
    //         }
    //     }
    // }

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
