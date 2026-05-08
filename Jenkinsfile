pipeline {
    agent any

    environment {
        // This dynamically gets the email of the person (Professor or You) who pushed the code
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                // Ensures the app is fresh and running for the tests
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 20 seconds for initialization..."
                sleep 20 
            }
        }

        stage('Clone Tests') {
            steps {
                echo "Cloning Selenium Test Repository..."
                // Using a unique folder name to avoid Git conflicts
                sh 'rm -rf test-stage'
                sh 'git clone https://github.com/abdullahashrafdev/memos-testing.git test-stage'
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                // Mapping the subfolder 'test-stage' where the POM lives
                sh '''
                docker run --rm \
                -v ${WORKSPACE}/test-stage:/usr/src/app \
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
            echo "Sending results to ${COMMITTER_EMAIL}..."
            emailext (
                to: "${COMMITTER_EMAIL}, abdullahhashraf@gmail.com",
                subject: "Assignment 3: Pipeline Results - Build #${env.BUILD_NUMBER}",
                body: "The Jenkins pipeline for Assignment 3 has finished.\n\nStatus: ${currentBuild.currentResult}\n\nCheck the attached log for results of the 15 Selenium tests.",
                attachLog: true
            )
        }
    }
}
