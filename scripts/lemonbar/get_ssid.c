#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/wireless.h>
#include <errno.h>

int main() {
        // Change this to your desired interface name:
        static const char *interface = "wlp2s0";

        struct iwreq req;
        strcpy(req.ifr_ifrn.ifrn_name, interface);
        int fd;
        fd = socket(AF_INET, SOCK_DGRAM, 0);
        char* buffer;
        buffer = calloc(32, sizeof(char));
        req.u.essid.pointer = buffer;
        req.u.essid.length = 32;

        if(ioctl(fd, SIOCGIWESSID, &req) == -1) {
        	fprintf(stderr, "Failed ESSID get on interface %s: %s\n", interface, strerror(errno));
        } else {
        	printf("%s", (char*)req.u.essid.pointer);
        }
        free(buffer);
}
