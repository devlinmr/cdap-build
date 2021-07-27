pipeline {
  parameters {
    string defaultValue: 'git@github.com:devlinmr/cdap-build.git', description: 'cdap-build repo to build from.', name: 'GIT_REPO', trim: false
    string defaultValue: 'devlinmr', description: 'Git repo credentials.', name: 'GIT_REPO_CREDENTIALS'
    string defaultValue: '', description: 'Git commit to build from.', name: 'GIT_COMMIT', trim: false
    string defaultValue: 'add-build-ci', description: 'Git branch to build from.', name: 'GIT_BRANCH', trim: false
    string defaultValue: 'latest', description: 'Docker tag to apply.', name: 'DOCKER_IMAGE_TAG', trim: false
    string defaultValue: 'devlm/cdap', description: 'Docker image to build.', name: 'DOCKER_IMAGE', trim: false
  }
  agent {
    kubernetes {
      defaultContainer 'kaniko'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    deployPipeline: build_ecr_image_Pipeline
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    tty: true
    command:
    - cat
  - name: cdap-build
    image: gcr.io/cdapio/cdap-build:latest
    tty: true
    command:
    - cat
"""
    }
  }
  stages {
    stage('Build Image') {
      steps {
        container('kaniko') {
        echo 'Building container'
        sh """
            /kaniko/executor \
              --context ${WORKSPACE} \
              --dockerfile ${WORKSPACE}/Dockerfile \
              --destination "${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}" \
              --no-push
        """
        }
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
