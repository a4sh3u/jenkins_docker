import hudson.model.FreeStyleBuild
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowRun
import org.jenkinsci.plugins.workflow.support.steps.StageStepExecution


def removeQueues() {
  def q = Jenkins.instance.queue
  q.items.each {
      q.cancel(it.task)
  }
}


def killAllrunnigjobs() {
  long time_in_millis = 10
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
