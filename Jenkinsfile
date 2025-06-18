pipeline {
    agent any
    environment {
	awsCreds = 'aws_credentials'
        dockerCreds = credentials('dockerhub_login')
	registry = "${dockerCreds_USR}/vatcal"
	registryCredentials = "dockerhub_login"
	dockerImage = ""
    }
    stages {
	stage('Run Tests') {
	    steps {
		npm 'install'
		npm 'test'
	    }
	}
	stage('Build Image') {
	    steps {
		script {
		    dockerImage = docker.build(registry)
		}
	    }
        }
	stage('Push Image') {
	    steps {
		script {
		    docker.withRegistry("", registryCredentials) {
			dockerImage.push("$env.BUILD_NUMBER")
			dockerImage.push("latest")
		    }
		}
	    }
	}
	stage('Clean Up') {
	    steps {
		sh "docker image prune --all --force --filter 'until=48h'"
	    }
	}
	stage('Provision Server') {
	    steps {
		script {
		    withCredentials([file(credentialsId: awsCreds, variable: 'AWS_CREDENTIALS')]) {
			sh 'echo "creds_file = $AWS_CREDENTIALS" > terraform.tfvars'
			sh 'terraform init'
			sh 'terraform apply'
		     }
		}
	    }
	}
    }
}
