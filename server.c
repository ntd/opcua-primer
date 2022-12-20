#include <open62541/plugin/log_stdout.h>
#include <open62541/server.h>
#include <open62541/server_config_default.h>
#include "OpcTestModel.h"

#include <signal.h>
#include <stdlib.h>


static volatile UA_Boolean running = true;


static void
stopHandler(int sig)
{
    UA_LOG_INFO(UA_Log_Stdout, UA_LOGCATEGORY_USERLAND, "received ctrl-c");
    running = false;
}

int main(void)
{
    UA_StatusCode retval;

    signal(SIGINT, stopHandler);
    signal(SIGTERM, stopHandler);

    UA_Server *server = UA_Server_new();
    UA_ServerConfig_setDefault(UA_Server_getConfig(server));


    retval = OpcTestModel(server);
    if (retval != UA_STATUSCODE_GOOD) {
        UA_LOG_ERROR(UA_Log_Stdout, UA_LOGCATEGORY_SERVER,
                     "OpcTestModel returned %d", (int) retval);
        return EXIT_FAILURE;
    }

    retval = UA_Server_run(server, &running);
    UA_Server_delete(server);
    return retval == UA_STATUSCODE_GOOD ? EXIT_SUCCESS : EXIT_FAILURE;
}
