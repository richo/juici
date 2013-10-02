CC = clang
CFLAGS += -Isrc
PROTOC_OPTS = --c_out src

PROTOBUF_CFLAGS = -lprotobuf-c
PROTOBUFS = src/proto/build_payload.pb-c.o
BINS = bin/juici

all: $(BINS)

bin/juici: $(PROTOBUFS) src/main.c
	$(CC) -o $@ $(CFLAGS) src/main.c $(PROTOBUFS) $(PROTOBUF_CFLAGS)

src/proto/%.pb-c.c: proto/%.proto
	protoc-c ${PROTOC_OPTS} $^

src/proto/%.pb-c.o: src/proto/%.pb-c.c
	$(CC) -c $(CFLAGS) -o $@ $^
