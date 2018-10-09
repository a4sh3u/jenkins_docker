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
          echo "1"
          Jenkins.instance.doQuietDown()
          echo "2"
          def pipeline = load 'groovy_scripts/kill.groovy'
          echo "3"
          pipeline.removeQueues()
          echo "4"
          pipeline.killAllrunnigjobs()
        }
      }
    }

    stage('Restart Jenkins') {
      steps {
        script {
          echo "5"
          Jenkins.instance.restart()
          echo "6"
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
