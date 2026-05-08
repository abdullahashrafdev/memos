pipeline {
    agent any

    environment {
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos..."
                sh 'docker-compose up -d --build'
                sleep 15 // Time for app to initialize
            }
        }

        stage('Clone Tests') {
            steps {
                // DELETE old folder if it exists
                sh 'rm -rf memos-testing'
                // CHANGE 'YOUR_GITHUB_USER' below
                sh 'git clone https://github.com/abdullahashrafdev/memos-testing.git'
            }
        }

        stage('Run Selenium Tests') {
            steps {
                dir('memos-testing') {
                    sh '''
                    docker run --rm \
                    -v $(pwd):/usr/src/app \
                    -w /usr/src/app \
                    --network host \
                    markhobson/maven-chrome:jdk-17 \
                    mvn clean test
                    '''
                }
            }
        }
    }

    post {
        always {
            emailext (
                to: "${COMMITTER_EMAIL}",
                subject: "Assignment 3: Pipeline Results - Build #${env.BUILD_NUMBER}",
                body: "Pipeline finished with status: ${currentBuild.currentResult}. Log attached.",
                attachLog: true
            )
        }
    }
}
