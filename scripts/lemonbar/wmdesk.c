/* wmdesk - display current desktop name */
/* To the extent possible under law, Christian Neukirchen has waived
   all copyright and related or neighboring rights to this work.
   http://creativecommons.org/publicdomain/zero/1.0/
*/

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
  Display *dpy;
  Window root;
  Atom netcurrentdesktop, netdesktopnames, real;

  int format, all;
  unsigned long extra, n, desktop;
  unsigned char *data, *name;
  
  if (argc > 2 || (argc == 2 && strcmp(argv[1], "-h") == 0)) {
    printf("wmdesk      display the currently active desktop\n");
    printf("wmdesk -a   display all desktops, current is marked with *\n");
    printf("wmdesk -n   display the index of the current desktop\n");
    exit(0);
  }
  
  if (!(dpy = XOpenDisplay(0)))
    exit(1);
  
  root = XDefaultRootWindow(dpy);
  netcurrentdesktop = XInternAtom(dpy, "_NET_CURRENT_DESKTOP", False);
  netdesktopnames = XInternAtom(dpy, "_NET_DESKTOP_NAMES", False);

  if(XGetWindowProperty(dpy, root, netcurrentdesktop, 0, ~0, False,
                        AnyPropertyType, &real, &format, &n, &extra,
                        &data) != Success && data != 0)
    exit(2);
    
  desktop = *(unsigned long *) data;
  XFree (data);

  if (argc == 2 && strcmp(argv[1], "-n") == 0) {
    printf("%ld\n", desktop);
    exit(0);
  }

  if(XGetWindowProperty(dpy, root, netdesktopnames, 0, ~0, False,
                        AnyPropertyType, &real, &format, &n, &extra,
                        &data) != Success && data != 0 && format != 8)
    exit(3);

  name = data;

  if (argc == 2 && strcmp(argv[1], "-a") == 0) {
    while (name-data < n) {
      printf("%c%s", desktop-- ? ' ' : ' ', name);
      name += strlen((char *) name) + 1;
    }
  } else {
    while (desktop > 0)
      if (*name++ == 0)
        desktop--;
    printf("%s", name);
  }


  XSync(dpy, False);
  XCloseDisplay(dpy);
  return 0;
}
