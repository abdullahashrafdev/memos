pipeline {
    agent any
    environment {
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }
    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos..."
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 60 seconds for app and database..."
                sleep 60 
            }
        }
        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                sh """
                docker run --rm --network host \
                markhobson/maven-chrome:jdk-17 \
                /bin/bash -c "git clone https://github.com/abdullahashrafdev/memos-testing.git tests && cd tests && mvn clean test"
                """
            }
        }
    }
    post {
        always {
            emailext (
                to: "${COMMITTER_EMAIL}, abdullahhashraf@gmail.com",
                subject: "Assignment 3 Result - Build #${env.BUILD_NUMBER}",
                body: "Status: ${currentBuild.currentResult}. Check logs for Selenium results.",
                attachLog: true
            )
        }
    }
}
