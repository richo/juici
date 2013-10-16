import socket
import unittest

from juici_server import JuiciServer

class JuiciTestCase(unittest.TestCase):
    def setUp(self):
        self.server = JuiciServer()

    def socket(self):
        sock = socket.socket(socket.AF_UNIX)
        sock.connect("/tmp/juici.sock")
        return sock

    def tearDown(self):
        self.server.shutdown()
