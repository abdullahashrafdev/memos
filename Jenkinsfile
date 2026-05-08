pipeline {
    agent any

    environment {
        COMMITTER_EMAIL = "qasimalik@gmail.com, abdullahhashraf@gmail.com"
    }

    stages {
        stage('Deploy Application') {
            steps {
                echo "Deploying Memos Application..."
                sh 'docker-compose up -d --build --force-recreate'
                echo "Waiting 20 seconds for initialization..."
                sleep 20 
            }
        }

        stage('Clone Tests') {
            steps {
                echo "Cloning Selenium Test Repository into Workspace..."
                // Cleaning the specific files to avoid git conflicts
                sh 'rm -rf .git src pom.xml README.md' 
                // Cloning into the current directory (.)
                sh 'git clone https://github.com/abdullahashrafdev/memos-testing.git .'
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo "Executing 15 Automated Test Cases..."
                // Mapping the root workspace directly to /usr/src/app
                sh '''
                docker run --rm \
                -v ${WORKSPACE}:/usr/src/app \
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
                body: "The Jenkins pipeline for Assignment 3 has finished.\n\nStatus: ${currentBuild.currentResult}\n\nPlease check the attached log for Selenium test results.",
                attachLog: true
            )
        }
    }
}
