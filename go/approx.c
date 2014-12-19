int ht,wd,l[99],r[99],cl[99];

int legal()			/* legality of random (ht,wd) go board */
{
  int c,y,x;

  for (x=0; x<=wd; x++)
    cl[l[x] = r[x] = x] = 3;
  for (y=ht; y--;) {
    for (x=1; x<=wd; x++) {
      if (c = random() % 3) {
        if (cl[x] == 3-c) {
          if (r[x] == x) return 0;
          l[r[l[x]] = r[x]] = l[x];
          l[x] = r[x] = x;
        }
        if (cl[x-1] == c && l[x]|r[x-1]) {
          l[r[l[x]]=r[x-1]] = l[x];
          l[r[x-1] = x] = x-1;
        }
        if (!cl[x-1]) r[x] = l[r[x]] = 0;
      } else l[x] = r[x] = r[l[x]] = l[r[x]] = r[x-1] = l[r[x-1]] = 0;
      cl[x] = c;
    }
  }
  for (x=1; x<=wd; x++) {
    if (r[x] == x) return 0;
    l[r[l[x]] = r[x]] = l[x];
  }
  return 1;
}

main(argc,argv)
int argc;
char *argv[];
{
  int tr,sc,t;

  if (argc==1) {
    printf ("usage: %s width [height] [trials]\n", argv[0]);
    exit(0);
  }
  ht = atoi(argv[1]);
  wd = argc > 2 ? atoi(argv[2]) : ht;
  tr = argc > 3 ? atoi(argv[3]) : 1000;
  srandom(getpid());
  for (sc=t=0; t++<tr; sc += legal()) ;
  printf("%.6f\n",sc/(float)tr);
}
