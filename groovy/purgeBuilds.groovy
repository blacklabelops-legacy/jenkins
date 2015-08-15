import hudson.model.*

def jobs = Jenkins.instance.projects.collect { it.name }
jobs.each {
  def jobi = Jenkins.instance.getItem( it )
  jobi.getBuilds().each { it.delete() }
}
