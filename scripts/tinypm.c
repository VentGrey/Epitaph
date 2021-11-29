#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <libnotify/notify.h>

int main() {
    while (true) {
            unsigned int maxc,
                    lowc,
                    critc,
                    deadc,
                    sleep_time;
            bool notified = false;
            char *dead_action = "suspend";
            char bcap[4], bstat[13];

            // Read battery status
            FILE *bfd = NULL;
            bfd = fopen("/sys/class/power_supply/BAT1/capacity", "r");
            // Handle read error
            if (!bfd) {
                    fprintf(stderr, "Error: can't read the battery capacity\n");
                    return -1;
            }

            FILE *sfd = NULL;
            sfd = fopen("/sys/class/power_supply/BAT1/status", "r");
            // Handle read error
            if (!sfd) {
                    fprintf(stderr, "Error: can't read the battery status\n");
                    return -1;
            }

            // Save all chars in their respective arrays
            fscanf(bfd, "%s", bcap);
            fscanf(sfd, "%s", bstat);

            // Convert battery cap to int
            int ncap = atoi(bcap);
            // close battery cap
            fclose(bfd);


            printf("%d", ncap);
            printf("%s", bstat);

            if (strcmp(bstat, "Discharging") == 0) {

            }

            fclose(sfd);
    }
    return 0;
}
