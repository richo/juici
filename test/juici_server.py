import os
import signal
import subprocess as sp

class JuiciServer(object):
    """Wraps an instance of the juici server

    Lighting up more than one is a Bad Thing"""

    instances = []

    def __init__(self):
        self.instances.append(self)
        if len(self.instances) > 1:
            raise RuntimeError("More than one JuiCI is a Bad Thing")
        self.process = self._start_juici()

    def _start_juici(self):
        return sp.Popen("bin/juici")

    def shutdown(self):
        os.kill(self.process.pid, signal.SIGINT)
        pid, status, rusage = os.wait4(self.process.pid, 0)
        self.instances.remove(self)
