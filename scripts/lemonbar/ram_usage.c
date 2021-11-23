#include <stdio.h>
#include <sys/sysinfo.h>

typedef struct sysinfo sysinfo_t;

int main()
{
        sysinfo_t info;
        sysinfo(&info);

        long usage = info.totalram - info.freeram;
        float percent = 100 * ((float)usage / info.totalram);

        const float byte_to_gb = 1024 * 1024 * 1024;

        float usage_gb = usage / byte_to_gb;

        printf("%.2f GB", usage_gb);
        return 0;
}
