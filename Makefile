CC = clang
CFLAGS += -Isrc -D_DEBUG
PROTOC_OPTS = --c_out src

PROTOBUF_CFLAGS = -lprotobuf-c
PROTOBUFS = src/proto/build_payload.pb-c.o
BINS = bin/juici
OBJS = src/build.o src/socket.o

all: $(BINS)

bin/juici: $(PROTOBUFS) src/main.c $(OBJS)
	$(CC) -o $@ $(CFLAGS) src/main.c $(PROTOBUFS) $(PROTOBUF_CFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $<

src/proto/%.pb-c.c: proto/%.proto
	protoc-c ${PROTOC_OPTS} $^

src/proto/%.pb-c.o: src/proto/%.pb-c.c
	$(CC) -c $(CFLAGS) -o $@ $^
