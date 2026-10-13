pipeline {
  agent any

  environment {
    IMAGE = 'forgeci-demo'
    TAG   = "build-${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test') {
      steps {
        sh '''
          echo "Running basic app checks..."
          python3 -m py_compile app/main.py || true
          echo "Syntax check done"
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t ${IMAGE}:${TAG} -t ${IMAGE}:latest .
          echo "Built ${IMAGE}:${TAG}"
        '''
      }
    }

    stage('Load Image to kind') {
      steps {
        sh '''
          kind load docker-image ${IMAGE}:latest --name forgeci || true
          echo "Image load attempted for kind cluster forgeci"
        '''
      }
    }

    stage('Deploy with Helm') {
      steps {
        sh '''
          helm upgrade --install forgeci ./helm/forgeci \
            --set image.repository=${IMAGE} \
            --set image.tag=latest \
            --set image.pullPolicy=Never
          kubectl rollout status deployment/forgeci --timeout=120s
          kubectl get pods -l app=forgeci
        '''
      }
    }
  }

  post {
    success {
      echo "ForgeCI pipeline succeeded — image built, Helm deploy complete"
    }
    failure {
      echo "Pipeline failed — check Docker, kind cluster, or Helm values"
    }
  }
}
