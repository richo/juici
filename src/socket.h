#ifndef __JUICI_SOCKET_H
#define __JUICI_SOCKET_H

#define JUICI_SOCKET_PATH "/tmp/juici.sock"

int juici_socket(void);
BuildPayload* load_payload(int sock);
void accept_new_connection(int socket, fd_set* fds);

#endif
