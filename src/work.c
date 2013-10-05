#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <errno.h>

#include "proto/build_payload.pb-c.h"

#include "socket.h"
#include "build.h"
#include "log.h"

void mainloop(int socket) {
    uint8_t butts[2048];
    int res, i;
    size_t rcvd;
    pid_t build;
    BuildPayload* msg;
    fd_set fds;
    fd_set rfds, wfds, efds;
    FD_ZERO(&fds); FD_ZERO(&rfds); FD_ZERO(&wfds); FD_ZERO(&efds);

    FD_SET(socket, &fds);

    while(1) {
        FD_ZERO(&rfds); FD_ZERO(&wfds); FD_ZERO(&efds);
        FD_COPY(&fds, &rfds); FD_COPY(&fds, &wfds); FD_COPY(&fds, &efds);
        res = select(FD_SETSIZE, &rfds, NULL, &efds, NULL);
        info("got %d fds\n", res);
        if (res == 0) {
            // timeout wtf?
        } else if (res == -1) {
            info("Child process exited\n");
            break;
            // We probably saw a signal. Defer signals and do some stuff.
        } else {
            for (i = 0; i < FD_SETSIZE; ++i) {
                if (FD_ISSET(i, &efds)) {
                    debug("%d has made a whoopsie\n", i);
                }
                if (!FD_ISSET(i, &rfds))
                    continue;

                if (i == socket) {
                    accept_new_connection(socket, &fds);
                    info("Accepted a new connection\n");
                } else {
                    // Check if the socket is still alive
                    if (recv(i, butts, 1, MSG_PEEK) < 1) {
                        close(i);
                        FD_CLR(i, &fds);
                        continue;
                    }
                    msg = load_payload(i);
                    if (!msg) {
                        info("Got a null payload from %d\n", i);
                        continue;
                    }
                    info("command -> %s\n", msg->command);
                    build = start_build(msg);
                    info("Started a new build from %d\n", i);
                }
            }
        }
    }
}
