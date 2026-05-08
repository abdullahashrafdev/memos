pipeline {
    agent any

    environment {
        // Dynamically identifies the person who pushed code
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 60 seconds for database and app to stabilize..."
                sleep 60 
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                // Self-contained clone and test to avoid pathing issues
                sh """
                docker run --rm \
                --network host \
                markhobson/maven-chrome:jdk-17 \
                /bin/bash -c "git clone https://github.com/abdullahashrafdev/memos-testing.git tests && cd tests && mvn clean test"
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
                body: "Status: ${currentBuild.currentResult}\n\nReview the attached build log for Selenium results.",
                attachLog: true
            )
        }
    }
}
