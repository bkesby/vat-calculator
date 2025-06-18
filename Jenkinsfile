pipeline {
    agent any
    environment {
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
	stage('Dive Analysis') {
	    steps {
		sh "CI=true dive registry"
	    }
	}
	stage('Grype Analysis') {
	    steps {
		sh "grype registry --scope all-layers"
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
    }
}
