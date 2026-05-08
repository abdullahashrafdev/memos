pipeline {
    agent any

    environment {
        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae' HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 20 seconds for services to initialize..."
                sleep 20 
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                /* We combine everything into one Docker command. 
                   The container clones the repo internally, so there are no pathing errors.
                */
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
                body: "The Jenkins pipeline for Assignment 3 has finished.\n\nStatus: ${currentBuild.currentResult}\n\nCheck the log for details.",
                attachLog: true
            )
        }
    }
}
