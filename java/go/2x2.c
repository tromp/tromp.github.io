/* C program to solve 2x2 go with area rules and positional superko */
/* note that suicide is not possible in this case */
/* trying moves before passes slows search dramatically */

#include <stdio.h>
#define NSHOW 4
#define NMOVES 4
#define CUT 1   /* 0 for plain minimax */
#define MAXN 22 /* maximum game length, show all games at this length */

char h[256];   /* bitmap of positions in game history */
int nodes[100]; /* number of nodes visited at each depth */
int whites[100],blacks[100]; /* move history */
long ngames;
long ngamesatdepth[100];

void show(int n)
	/* print 2-line ascii representation of position */
{
  for (int j=0; j<=n; j++) {
    printf("%d\n", j);
    for (int i=0; i<4; i++) {
      printf(" %c", ".XO#"[(blacks[j]>>i&1)+2*(whites[j]>>i&1)]);
      if (i&1)
        putchar('\n');
  }
  }
}

void visit(int n)
{
  h[blacks[n] +16* whites[n]] = 1;
}

void unvisit(int n)
{
  h[blacks[n] +16* whites[n]] = 0;
}

int visited(int n)
{
  return h[blacks[n] +16* whites[n]];
}

int owns(int bb)
{
  return bb == (1|8) || bb == (2|4);
}

int popcnt[16] = {0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4}; /* number of 1 bits */

int score(int n)
{
  ngames++;
  ngamesatdepth[n]++;
  if (blacks[n]==0)
    return whites[n] ? -4 : 0;
  if (whites[n]==0)
    return 4;
  else return popcnt[blacks[n]]-popcnt[whites[n]];
}

int xhasmove(int n, int move)
{
  move = 1<<move;
  if ((blacks[n]|whites[n])&move || popcnt[blacks[n]]==3 || owns(whites[n]))
    return 0;
  blacks[n+1] = blacks[n] | move;
  whites[n+1] = (blacks[n+1]|whites[n])==15 || owns(blacks[n+1]) ? 0 : whites[n];
  return !visited(n+1);
}

void pass(int n) {
  whites[n+1] = whites[n];
  blacks[n+1] = blacks[n];
}

int ohasmove(int n, int move)
{
  move = 1<<move;
  if ((blacks[n]|whites[n])&move || popcnt[whites[n]]==3 || owns(blacks[n]))
    return 0;
  whites[n+1] = whites[n] | move;
  blacks[n+1] = (whites[n+1]|blacks[n])==15 || owns(whites[n+1]) ? 0 : blacks[n];
  return !visited(n+1);
}

int xab(int n, int alpha, int beta, int passed)
{
  int i,s;
  int oab(int, int, int, int);

  nodes[n]++;
  if (n == MAXN)
    show(n);

  s = passed ? score(n) : (pass(n), oab(n+1,alpha,beta,1));
  if (s > alpha && (alpha=s) >= beta && CUT) return alpha;

  for (i=0; i<NMOVES; i++) {
    if (xhasmove(n,i)) {
      visit(n+1);
      s = oab(n+1, alpha, beta, 0);
      unvisit(n+1);
      if (s > alpha && (alpha=s) >= beta && CUT) return alpha;
    }
  }

  return alpha;
}

int oab(int n, int alpha, int beta, int passed)
{
  int i,s;

  nodes[n]++;
  if (n == MAXN)
    show(n);

  s = passed ? score(n) : (pass(n), xab(n+1,alpha,beta,1));
  if (s < beta && (beta=s) <= alpha && CUT) return beta;

  for (i=0; i<NMOVES; i++) {
    if (ohasmove(n,i)) {
      visit(n+1);
      s = xab(n+1, alpha, beta, 0);
      unvisit(n+1);
      if (s < beta && (beta=s) <= alpha && CUT) return beta;
    }
  }

  return beta;
}

int main()
{
  int i,c,s;
  blacks[0] = whites[0] = 0;
  c = xab(0, -4, 4, 0);
  for (i=s=0; nodes[i]; i++) {
    s += nodes[i];
    printf("%d: %d\n", i, nodes[i]);
  }
  for (i=0; nodes[i]; i++)
    printf("%2d: nodes %d games %ld\n", i, nodes[i], ngamesatdepth[i]);
  printf("total: %d\nngames: %ld\nx wins by %d\n", s, ngames, c);
  return 0;
}
