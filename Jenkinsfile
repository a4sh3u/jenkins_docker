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

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(daysToKeepStr: '70'))
  }

  stages {
    stage('Delete Qs & Kill Jobs') {
      steps {
        script {
          def q = Jenkins.instance.queue
          q.items.each {
              q.cancel(it.task)
          }
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
