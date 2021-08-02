pipeline {
  parameters {
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
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    projected:
      sources:
      - secret:
          name: docker-creds
          items:
            - key: .dockerconfigjson
              path: config.json
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
  }
}
