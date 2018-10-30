#!/usr/bin/env groovy
import hudson.model.FreeStyleBuild
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowRun
import org.jenkinsci.plugins.workflow.support.steps.StageStepExecution

pipeline {

  agent any

  triggers {
    cron('0 4 * * *')
  }

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(daysToKeepStr: '70'))
  }

  stages {
    stage('Check User') {
      steps {
        script {
          wrap([$class: 'BuildUser']) {
            // sh "echo \${BUILD_USER_EMAIL}"
            // ISUSERTIMER = sh(script: "if [[ -z \${BUILD_USER_EMAIL+x} ]]; then echo 0; else echo 1; fi", returnStdout: true).trim()
            sh "if [ -z \${BUILD_USER_EMAIL+x} ]; then export USER='timer'; else export USER='nottimer';fi; echo \${USER}"
            sh "printenv"
            if (
              env.USER == "timer"
            ) {
              mail body: "${BUILD_USER_EMAIL} tried to restart Jenkins, but failed miserably. You probably want to take some legal action against him/her. So, consult the SMAVA legal team." ,
              from: 'jenkins2@smava.de',
              replyTo: 'jenkins2@smava.de',
              subject: "${BUILD_USER_EMAIL} tried to restart Jenkins",
              to: 'ashutosh.singh@smava.de,rahul.swaminathan@smava.de,david.constenla-rodriguez@smava.de'
              error('Aborting the build. This is privileged job and mortals can not execute it. This issue will be reported to the DevOps gods and appropriate divine punishment will be handed to the perpetrator.')
            }
          }
        }
      }
    }

    stage('Delete Qs & Kill Jobs') {
      steps {
        script {
          def q = Jenkins.instance.queue
          q.items.each {
              q.cancel(it.task)
          }
          println "ALL Queues Cancelled"
          long time_in_millis = 10000
          Calendar rightNow = Calendar.getInstance()
          Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
              job.isBuilding()
          }.collect { Job job ->
              job.builds.findAll { Run run ->
                  run.isBuilding() && ((rightNow.getTimeInMillis() - run.getStartTimeInMillis()) > time_in_millis)
              } ?: []
          }.sum().each { Run item ->
              if(item in WorkflowRun) {
                  println "Trying to kill ${item}"
                  WorkflowRun run = (WorkflowRun) item
                  run.doKill()
                  StageStepExecution.exit(run)
                  println "Killed ${run}"
              } else if(item in FreeStyleBuild) {
                  FreeStyleBuild run = (FreeStyleBuild) item
                  run.executor.interrupt(Result.ABORTED)
                  println "Killed ${run}"
              } else {
                  println "WARNING: Don't know how to handle ${item.class}"
              }
          }
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
