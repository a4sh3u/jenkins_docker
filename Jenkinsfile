#!/usr/bin/env groovy

pipeline {

  agent any

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(daysToKeepStr: '70'))
  }

  stages {
    stage('KILL ALL JOBS & QUEUES') {
      steps {
        script {
          def pipeline = load 'groovy_scripts/kill.groovy'
          pipeline.removeQueues()
          pipeline.killAllrunnigjobs()
        }
      }
    }
  }

  post {
    always {
      deleteDir()
    }
    success {
      echo "Yay, we passed."
    }
    failure {
      echo "Boo, we failed."
    }
  }
}
