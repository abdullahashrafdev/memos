pipeline {
    agent any

    environment {
        // Dynamically identifies the person who pushed (Professor or You)
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                // Ensures a clean, fresh deployment for testing
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 20 seconds for services to initialize..."
                sleep 20 
            }
        }

        stage('Clone Tests') {
            steps {
                echo "Fetching Selenium test code from GitHub..."
                sh 'rm -rf test-stage'
                sh 'git clone https://github.com/abdullahashrafdev/memos-testing.git test-stage'
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                // Using double quotes allows Jenkins to resolve the path before running Docker
                sh """
                docker run --rm \
                -v ${env.WORKSPACE}/test-stage:/usr/src/app \
                -w /usr/src/app \
                --network host \
                markhobson/maven-chrome:jdk-17 \
                mvn clean test
                """
            }
        }
    }

    post {
        always {
            echo "Sending results to ${COMMITTER_EMAIL}..."
            emailext (
                to: "${COMMITTER_EMAIL}, abdullahhashraf@gmail.com",
                subject: "Assignment 3: Pipeline Results - Build #${env.BUILD_NUMBER}",
                body: "The Jenkins pipeline for Assignment 3 has finished.\n\nStatus: ${currentBuild.currentResult}\n\nPlease review the attached log for details on the Selenium tests.",
                attachLog: true
            )
        }
    }
}
