#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include "proto/build_payload.pb-c.h"

#include "log.h"
#include "socket.h"
#include "work.h"


int main(int argc, char** argv) {
    int sock = juici_socket();
    listen(sock, 16);

    mainloop(sock);
}
