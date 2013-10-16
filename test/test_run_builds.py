import time
import struct
import tempfile

from juici_testcase import JuiciTestCase
from proto.build_payload_pb2 import BuildPayload

class TestRunBuilds(JuiciTestCase):
    def test_can_run_builds(self):
        directory = tempfile.mkdtemp()

        bp = BuildPayload()
        bp.workspace = "test"
        bp.title = "test"
        bp.command = "echo butts > %s/file" % directory
        bp.priority = 10

        payload = bp.SerializeToString()
        length = len(payload)
        payload = struct.pack(">I", length) + payload
        # Give juici a sec to boot
        time.sleep(1) # Ew
        sock = self.socket()
        sock.send(payload)
        time.sleep(1) # Ew

        with open("%s/file" % directory, "r") as fh:
            self.assertEqual(fh.read(), "butts\n")
