#include <sys/socket.h>
#include <sys/un.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>

#include "proto/build_payload.pb-c.h"

#include "socket.h"

int juici_socket(void) {
    struct sockaddr_un local;
    int len, sock, res;
    sock = socket(AF_UNIX, SOCK_STREAM, 0);

    local.sun_family = AF_UNIX;
    strcpy(local.sun_path, JUICI_SOCKET_PATH);
    len = sizeof(local.sun_path) + sizeof(local.sun_family);

    if (sock == -1) {
        goto err;
    }

    unlink(JUICI_SOCKET_PATH);
    res = bind(sock, (struct sockaddr*)&local, len);

    if (res == -1) {
        goto err;
    }
    return sock;

err:
    fprintf(stderr, "%s", strerror(errno));
    return -1;
}

BuildPayload* load_payload(int sock, size_t size) {
    BuildPayload *msg;
    char c; int res=0, rcvd=0;
    uint8_t *buf = malloc(size);
    if (!buf) {
        return NULL;
    }

    while (rcvd < size)
    {
        res = recv(sock, buf + rcvd, size - rcvd, 0);
        if (res == -1) {
            goto err;
        }
        rcvd += res;
    }

    msg = build_payload__unpack(NULL,size,buf); // Deserialize the serialized input
    if (msg == NULL)
    {
        goto err;
    }
    return msg;
err:
    free(buf);
    return NULL;
}
