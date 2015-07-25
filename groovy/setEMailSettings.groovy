import jenkins.model.*

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("hudson.tasks.Mailer")

desc.setSmtpAuth("user", "userpass")
desc.setReplyToAddress("dummy@jenkins.bla")
desc.setSmtpHost("smpt host")
desc.setUseSsl(true)
desc.setSmtpPort("2525")
desc.setCharset("UTF-8")

desc.save()
inst.save()
