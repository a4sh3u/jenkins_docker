#!/usr/bin/env groovy

pipeline {

  agent any

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(daysToKeepStr: '70'))
  }

  stages {
    stage('Delete Qs & Kill Jobs') {
      steps {
        script {
          Jenkins.instance.doQuietDown()
          def pipeline = load 'groovy_scripts/kill.groovy'
          pipeline.removeQueues()
          pipeline.killAllrunnigjobs()
        }
      }
    }

    stage('Restart Jenkins') {
      steps {
        script {
          Jenkins.instance.restart()
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
