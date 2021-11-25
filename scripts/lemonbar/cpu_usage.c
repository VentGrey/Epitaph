/*
 * Copyright 2009-2021   Cosmin Cojocar <cosmin.cojocar@gmail.com>
 * & VentGrey (Omar Jair Purata Funes) <ventgrey@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef CPU_USAGE_H
#define CPU_USAGE_H

struct cpu_counters {
        long long total_jiffies;
        long long work_jiffies;
};

/* reads the current cpu counters from /proc/stat */
int read_cpu_counters(struct cpu_counters *cpu_cnt);

/* returns the cpu usage in percent */
float cpu_usage(const struct cpu_counters *cpu_cnt_start,
                const struct cpu_counters *cpu_cnt_end);

#endif

int main() {
        struct cpu_counters cpu_cnt_start, cpu_cnt_end;
        read_cpu_counters(&cpu_cnt_start);
        int i = 1;
        while (i--)
                sleep(1);
        read_cpu_counters(&cpu_cnt_end);
        printf("%3.0f%%", cpu_usage(&cpu_cnt_start, &cpu_cnt_end));
        return 0;
}

int read_cpu_counters(struct cpu_counters *cpu_cnt)
{
        FILE *f = NULL;
        char buf[256];
        char *rest = NULL, *token, *str;
        int ntok = 0;
        int err = 0;

        f = fopen("/proc/stat", "r");
        if (!f) {
                fprintf(stderr, "error: can't read the /proc/stat\n");
                return -1;
        }

        /* the cpu counters resides in the first line */
        if (!fgets(buf, 256, f)) {
                fprintf(stderr, "error: invalid cpu counters in /proc/stat \n");
                err = -1;
                goto out;
        }

        str = buf;
        memset(cpu_cnt, 0, sizeof(*cpu_cnt));
        while ((token = strtok_r(str, " ", &rest)) != NULL) {
                ++ntok;
                str = rest;
                /* skip the fist token */
                if (ntok == 1)
                        continue;
                if (ntok < 5)
                        cpu_cnt->work_jiffies += atoll(token);
                cpu_cnt->total_jiffies += atoll(token);
        }

out:
        fclose(f);
        return err;
}

float cpu_usage(const struct cpu_counters *cpu_cnt_start,
                const struct cpu_counters *cpu_cnt_end)
{
        return ((float)(cpu_cnt_end->work_jiffies - cpu_cnt_start->work_jiffies) /
                (float)(cpu_cnt_end->total_jiffies  \
                        - cpu_cnt_start->total_jiffies)) * 100;
}
