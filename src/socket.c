#include <sys/socket.h>
#include <sys/un.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/select.h>

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

BuildPayload* load_payload(int sock) {
    uint32_t msg_size;
    BuildPayload *msg;
    char c;
    int res = 0;
    size_t rcvd = 0;

    if(recv(sock, &msg_size, sizeof(uint32_t), MSG_WAITALL) != sizeof(uint32_t)) {
        return NULL;
    }

    msg_size = ntohl(msg_size);
    uint8_t *buf = malloc(msg_size);

    if (!buf) {
        goto err;
    }

    while (rcvd < msg_size)
    {
        res = recv(sock, buf + rcvd, msg_size - rcvd, 0);
        if (res == -1) {
            goto err;
        }
        rcvd += res;
    }

    msg = build_payload__unpack(NULL, msg_size, buf);
    if (msg == NULL)
    {
        goto err;
    }
    return msg;
err:
    free(buf);
    return NULL;
}

void accept_new_connection(int socket, fd_set* fds) {
    int fd = accept(socket, NULL, NULL);
    // TODO error handling
    FD_SET(fd, fds);
}
