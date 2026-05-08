pipeline {
    agent any

    environment {
        // Hardcoded emails for the professor and yourself
        COMMITTER_EMAIL = "qasimalik@gmail.com, abdullahhashraf@gmail.com"
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                // Ensures the app is fresh and running for the tests
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 20 seconds for database and app to initialize..."
                sleep 20 
            }
        }

        stage('Clone Tests') {
            steps {
                echo "Cloning Selenium Test Repository..."
                sh 'rm -rf memos-testing'
                sh 'git clone https://github.com/abdullahashrafdev/memos-testing.git'
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                // Using ${WORKSPACE} ensures the absolute path is passed to Docker
                sh '''
                docker run --rm \
                -v ${WORKSPACE}/memos-testing:/usr/src/app \
                -w /usr/src/app \
                --network host \
                markhobson/maven-chrome:jdk-17 \
                mvn clean test
                '''
            }
        }
    }

    post {
        always {
            echo "Sending results email..."
            emailext (
                to: "${COMMITTER_EMAIL}",
                subject: "Assignment 3: Pipeline Results - Build #${env.BUILD_NUMBER}",
                body: "The Jenkins pipeline for Assignment 3 has finished.\n\nStatus: ${currentBuild.currentResult}\n\nCheck the attached log for Selenium test results.",
                attachLog: true
            )
        }
    }
}
