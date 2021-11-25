#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int main()
{
        FILE *fd = NULL;
        fd = fopen("/proc/meminfo", "r");
        if (!fd)
                printf("Unkown");

        char *line = NULL;
        size_t len = 0;
        ssize_t read;

        unsigned long total = 0;
        unsigned long available = 0;

        for(int i = 0; i<3; i++) {
                line = NULL;
                len = 0;
                if((read = getline(&line, &len, fd)) != -1) {
                        if(i == 0) {
                                sscanf(line, "%*s %lu ", &total);
                        } else if (i == 2) {
                                sscanf(line, "%*s %lu ", &available);
                        }
                        free(line);
                }
        }
        printf("%.2lf GB", (double)(total - available) / (double)(1<<20));
        fclose(fd);
        return 0;
}
