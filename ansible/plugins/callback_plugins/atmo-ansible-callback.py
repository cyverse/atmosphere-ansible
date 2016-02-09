import os
import time
import datetime
from datetime import datetime, timedelta
import json

DEF_LOG_LOCATION = "/var/log/ansible/hosts"
LOGNAME = "LOGNAME"
LOGFOLDER = "LOGFOLDER"
TIME_FORMAT = "%b %d %Y %H:%M:%S"
MSG_FORMAT = "%(now)s - %(data)s\n\n"
SUMMARIZE_MSG_FORMAT = "%(now)s - summary: etime=%(elapsed_time)ss " \
    "ok=%(ok)s changed=%(changed)s unreachable=%(unreachable)s " \
    "failed=%(failed)s skipped=%(skipped)s\n\n"


class CallbackModule(object):

    start_time = datetime.now()
    logpath = None

    def __init__(self):
        self.start_time = datetime.now()
        self.logpath = None
        print "Host Logger plugin is active. Version 2"

    def on_any(self, *args, **kwargs):
        pass

    def runner_on_failed(self, host, res, ignore_errors=False):
        atmo_custom_log(host, self.logpath, res)

    def runner_on_ok(self, host, res):
        atmo_custom_log(host, self.logpath, res)

    def runner_on_error(self, host, msg):
        atmo_custom_log(host, self.logpath, msg)

    def runner_on_skipped(self, host, item=None):
        atmo_custom_log(host, self.logpath, item)

    def runner_on_unreachable(self, host, res):
        atmo_custom_log(host, self.logpath, res)

    def runner_on_no_hosts(self):
        pass

    def runner_on_async_poll(self, host, res, jid, clock):
        atmo_custom_log(host, self.logpath, res)

    def runner_on_async_ok(self, host, res, jid):
        atmo_custom_log(host, self.logpath, res)

    def runner_on_async_failed(self, host, res, jid):
        atmo_custom_log(host, self.logpath, res)

    def playbook_on_start(self):
        if LOGNAME in self.playbook.extra_vars:
            logname = self.playbook.extra_vars[LOGNAME]
            folder = DEF_LOG_LOCATION
            if LOGFOLDER in self.playbook.extra_vars:
                folder = self.playbook.extra_vars[LOGFOLDER]
            self.logpath = os.path.join(folder, logname)

    def playbook_on_notify(self, host, handler):
        pass

    def playbook_on_no_hosts_matched(self):
        pass

    def playbook_on_no_hosts_remaining(self):
        pass

    def playbook_on_task_start(self, name, is_conditional):
        pass

    def playbook_on_vars_prompt(self, varname, private=True, prompt=None,
                                encrypt=None, confirm=False, salt_size=None,
                                salt=None, default=None):
        pass

    def playbook_on_setup(self):
        pass

    def playbook_on_import_for_host(self, host, imported_file):
        pass

    def playbook_on_not_import_for_host(self, host, missing_file):
        pass

    def playbook_on_play_start(self, pattern):
        pass

    def playbook_on_stats(self, stats):
        hosts = stats.processed.keys()
        timedelta = datetime.now() - self.start_time
        for h in hosts:
            if self.logpath:
                s = stats.summarize(h)
                now = time.strftime(TIME_FORMAT, time.localtime())
                fd = open(self.logpath, "a")
                fd.write(SUMMARIZE_MSG_FORMAT %
                         dict(now=now, elapsed_time=timedelta.seconds,
                              ok=s["ok"],
                              changed=s["changed"],
                              unreachable=s["unreachable"],
                              failed=s["failures"],
                              skipped=s["skipped"]))
                fd.close()


def atmo_custom_log(host, logpath, data):

    if logpath is None:
        return

    if type(data) == dict:
        if 'verbose_override' in data:
            # avoid logging extraneous data from facts
            data = 'omitted'
        else:
            data = data.copy()
            invocation = data.pop('invocation', None)
            data = json.dumps(data)
            if invocation is not None:
                data = json.dumps(invocation) + " => %s " % data

    now = time.strftime(TIME_FORMAT, time.localtime())
    fd = open(logpath, "a")
    fd.write(MSG_FORMAT % dict(now=now, data=data))
    fd.close()
