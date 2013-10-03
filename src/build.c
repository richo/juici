#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "proto/build_payload.pb-c.h"
#include "build.h"

pid_t start_build(BuildPayload* payload) {
    // TODO create worktree
    // TODO locking
    // TODO signal mask
    // TODO output capture into unlinked file
    char filename[] = "/tmp/juici-XXXXXXXXX";
    pid_t pid;
    int scriptfd = mkstemp(filename);
    if (scriptfd == -1) {
        goto err;
    }
    FILE* script = fdopen(scriptfd, "w");
    if (!script) {
        goto err;
    }
    // TODO Write a shebang line if one doesn't exist
    if (fwrite(payload->command, strlen(payload->command), 1, script) != 1) {
        goto err;
    }

    switch(pid = fork()) {
        case -1: /* error */
            goto err;
        case 0: /* child */
            execl("/bin/sh", "/bin/sh", filename, (char*)0);
        default: /* parent */
            return pid;
    }

err:
    return 0;
}
