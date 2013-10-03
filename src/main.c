#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include "proto/build_payload.pb-c.h"

#include "log.h"
#include "build.h"
#include "socket.h"


int main(int argc, char** argv) {
    int sock = juici_socket();
    listen(sock, 16);
    uint32_t msg_size;
    int client = accept(sock, NULL, NULL);

    size_t rcvd = recv(client, &msg_size, sizeof(uint32_t), MSG_WAITALL);
    msg_size = ntohl(msg_size);
    pid_t build;

    BuildPayload* msg = load_payload(client, msg_size);
    if (msg != NULL) {
        printf("msg -> workspace: %s\n", msg->workspace);
        printf("msg -> priority : %d\n", msg->priority);
        printf("msg -> title    : %s\n", msg->title);
        printf("msg -> command  : %s\n", msg->command);

        build = start_build(msg);
        printf("build -> pid    : %d\n", build);
    }
}
