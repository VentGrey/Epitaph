#include <stdio.h>
#include <time.h>
#include <string.h>

#define BUF_LEN 256

int main()
{
        char buf[BUF_LEN] = {0};
        time_t rawtime = time(NULL);
        struct tm *ptm = localtime(&rawtime);

        if (rawtime == -1) {
                puts("The time() function failed");
                return 1;
        }

        if (ptm == NULL) {
                puts("The localtime() function failed");
                return 1;
        }

        strftime(buf, BUF_LEN, "%d/%m/%Y (%H:%M)", ptm);
        puts(buf);

        return 0;
}
