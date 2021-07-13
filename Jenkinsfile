pipeline {
	parameters {
		string defaultValue: 'git@github.com:devlinmr/cdap-build.git', description: 'cdap-build repo to build from.', name: 'GIT_REPO', trim: false
		string defaultValue: 'devlinmr', description: 'Git repo credentials.', name: 'GIT_REPO_CREDENTIALS'
		string defaultValue: '', description: 'Git commit to build from.', name: 'GIT_COMMIT', trim: false
		string defaultValue: 'add-build-ci', description: 'Git branch to build from.', name: 'GIT_BRANCH', trim: false
		string defaultValue: 'latest', description: 'Docker tag to apply.', name: 'DOCKER_IMAGE_TAG', trim: false
		string defaultValue: 'devlm/cdap', description: 'Docker image to build.', name: 'DOCKER_IMAGE', trim: false
	}
	agent any
	stages {
		stage("Checkout Source") {
			steps {
				git changelog: false, credentialsId: env.GIT_REPO_CREDENTIALS, poll: false, url: env.GIT_REPO, branch: env.GIT_BRANCH
			}
		}

		stage('Build Image') {
			steps {
				sh "make build"
			}
		}

		stage("Push Image") {
			steps {
        // TODO: Add credentials for ECR
        sh "make push"
			}
		}
	}
}
