import sys
import struct
import argparse
from proto.build_payload_pb2 import BuildPayload

parser = argparse.ArgumentParser()
parser.add_argument("--workspace", help="workspace to build in")
parser.add_argument("--title", help="title for the build")
parser.add_argument("--command", help="command to run")
parser.add_argument("--priority", type=int, help="priority for the build", default=1)
args = parser.parse_args()


b = BuildPayload()

b.workspace = args.workspace
b.title = args.title
b.command = args.command
b.priority = args.priority

payload = b.SerializeToString()
length = len(payload)
sys.stdout.write(struct.pack(">I", length))
sys.stdout.write(payload)
