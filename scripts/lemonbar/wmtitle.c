/* wmtitle - display the title of the currently active window */
/* To the extent possible under law, Christian Neukirchen has waived
   all copyright and related or neighboring rights to this work.
   http://creativecommons.org/publicdomain/zero/1.0/
*/

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
        Display *dpy;
        Window root;
        Atom netactivewindow, real;

        int format;
        unsigned long extra, n, window;
        unsigned char *data;

        if (argc > 1) {
                printf("wmtitle  \
display the title of the currently active window\n");
                exit(0);
        }
  
        if (!(dpy = XOpenDisplay(0))) {
                exit(1);
        }

        root = XDefaultRootWindow(dpy);
        netactivewindow = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", False);

        if(XGetWindowProperty(dpy, root, netactivewindow, 0, ~0, False,
                              AnyPropertyType, &real, &format, &n, &extra,
                              &data) != Success && data != 0)
                exit(2);

        window = *(unsigned long *) data;
        XFree (data);


        /* No active window.  */
        if (window == 0) {
                exit(0);
        }


        if(XGetWindowProperty(dpy, (Window) window, XA_WM_NAME, 0, ~0, False,
                              AnyPropertyType, &real, &format, &n, &extra,
                              &data) != Success && data != 0)
                exit(3);
  
        printf("%s\n", data);
        XFree (data);
  
        XSync(dpy, False);
        XCloseDisplay(dpy);
        return 0;
}
