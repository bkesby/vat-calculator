pipeline {
    agent any
    environment {
	awsCreds = 'aws_credentials'
        dockerCreds = credentials('dockerhub_login')
	registry = "${dockerCreds_USR}/vatcal"
	registryCredentials = "dockerhub_login"
	dockerImage = ""
	KUBECONFIG = "config.yaml"
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
	stage('Deploy to Kubernetes') {
	    steps {
		sh "cp -u /mnt/k3s/config config.yaml"
		sh "kubectl apply -f kubernetes/deploy.yml"
		sh "kubectl apply -f kubernetes/service.yml"
	    }
	}
    }
}
