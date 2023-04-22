/* C program to explore the 2x2 go graph for area rules and positional superko */
/* note that suicide is not possible in this case */

#include <stdio.h>

long nodes[57]; /* number of nodes visited at each depth */
int legalrank[256]; /* 0-56 rank of 4-bit white bitmap and 4-bit least significant black bitmap */

int owns(int bb) /* you own the board by having exactly two stones in opposing corners */
{
  return bb == (1|8) || bb == (2|4);
}

int legal(int black, int white)
{
  return !(black&white) && (black|white) != 15 && !(owns(black) && white) && !(owns(white) && black);
}

int ranklegal()
{
  int nlegal=0, black, white;
  for (white=0; white < 16; white++)
    for (black=0; black < 16; black++)
      legalrank[black+16*white] = legal(black, white) ? nlegal++ : -1;
  return nlegal;
}

void visit(int n, int black, int white, long visited)
{
  int i, biti, black1, white1, rank;
  long bitrank;

  rank = legalrank[black+16*white];
  bitrank = 1L << rank;
  if ((visited & bitrank) != 0)
    return;
  nodes[n]++;
  visited |= bitrank;
  for (biti=8; biti; biti>>=1) {
    if (biti & (black|white))
      continue;
    if ((black1 = black | biti) != 15 && !owns(white))
      visit(n+1, black1, legalrank[black1+16*white]<0 ? 0 : white, visited);
    if ((white1 = white | biti) != 15 && !owns(black))
      visit(n+1, legalrank[black+16*white1]<0 ? 0 : black, white1, visited);
  }
}

int main()
{
  int i;
  long sum;

  printf("%d legal 2x2 positions\n", ranklegal());
#ifdef FULL
  printf("Number of games is total\n");
  visit(0, 0, 0, 0);
#else
  printf("Fixing first move as Black A2\n");
  printf("Number of games is 1+8*total\n");
  visit(1, 1, 0, 1);
#endif
  for (i=sum=0; !i || nodes[i]; i++) {
    sum += nodes[i];
    printf("%d: %ld\n", i, nodes[i]);
  }
  printf("total: %ld\n", sum);
  return 0;
}
