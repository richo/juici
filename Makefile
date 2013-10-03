CC = clang
CFLAGS += -g -Isrc -D_DEBUG
PROTOC_OPTS = --c_out src

PROTOBUF_CFLAGS = -lprotobuf-c
PROTOBUFS = src/proto/build_payload.pb-c.o
TEST_PROTOBUFS = test/proto/build_payload_pb2.py
BINS = bin/juici
OBJS = src/build.o src/socket.o

.PHONY: test clean

all: $(BINS)

bin/juici: $(PROTOBUFS) src/main.c $(OBJS)
	$(CC) -o $@ $(CFLAGS) src/main.c $(PROTOBUFS) $(PROTOBUF_CFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $<

src/proto/%.pb-c.c: proto/%.proto
	protoc-c ${PROTOC_OPTS} $^

src/proto/%.pb-c.o: src/proto/%.pb-c.c
	$(CC) -c $(CFLAGS) -o $@ $^

clean:
	rm $(OBJS)
	rm $(BINS)
	rm $(PROTOBUFS)

## TESTS

test/proto/%_pb2.py: proto/%.proto
	protoc --python_out test $^

test: $(TEST_PROTOBUFS)
	./test/runtests
