#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;
typedef unsigned char uchar;
typedef struct {
  uint wking : 6;
  uint bking : 6;
  uint wferz : 5;
  uint bferz : 5;
  uint turn  : 1;
} pcs;

#define NBM   (1<<23)

uint ferz(uint f) {
  return f<<1 ^ (f>>2 & 1) ^ 1;
}

uint sqdist(uint pc0, uint pc1) {
  int y = pc0/8 - pc1/8;
  int x = pc0%8 - pc1%8;
  return x*x+y*y;
}

uint adj(uint pc0, uint pc1) {
  return sqdist(pc0,pc1) <= 2;
}

uint wins(pcs pc) {
  if (pc.turn)
    return 0;
  uint wferz = ferz(pc.wferz), bferz = ferz(pc.bferz);
  uint aff=adj(wferz,bferz), bfu=!adj(bferz,pc.bking), bfa=adj(pc.wking,bferz);
  return (aff && (bfu || bfa))  || (bfa && bfu && (!adj(pc.bking,wferz) || aff));
}

uint fails(pcs pc) {
  if (!pc.turn)
    return 0;
  uint wferz = ferz(pc.wferz), bferz = ferz(pc.bferz);
  return adj(bferz,wferz) || (adj(pc.bking,wferz) && !adj(wferz,pc.wking));
}

uint ok(pcs pc) {
  if (adj(pc.wking,pc.bking))
    return 0;
  if (pc.wferz == pc.bferz)
    return 0;
  uint wferz = ferz(pc.wferz);
  uint bferz = ferz(pc.bferz);
  if (wferz == pc.wking || wferz == pc.bking || bferz == pc.bking || bferz == pc.wking)
    return 0;
  if ((pc.turn && sqdist(pc.wking,bferz)==2) || (!pc.turn && sqdist(pc.bking,wferz)==2))
    return 0;
  return 1;
}

char cell(pcs pc, uint sq) {
  if (sq == pc.wking      ) return 'K';
  if (sq == pc.bking      ) return 'k';
  if (sq == ferz(pc.wferz)) return 'F';
  if (sq == ferz(pc.bferz)) return 'f';
  return '.';
}

typedef union {
  uint i;
  pcs  pc;
} imap;

void show(pcs pc) {
  uint y,x;
  for (y=0; y<8; y++) {
    for (x=0; x<8; x++)
      printf(" %c", cell(pc,8*y+x));
    printf("\n");
  }
}

#define FAIL 255
#define INF 254
uchar dist[NBM];

imap mvs[12];
uint nmv=0;

imap mv;
void try(uint _) { // add legal moves to mvs[] in best-to-worst order
  if (dist[mv.i]) {
    uint i,j;
    for (i=0; i<nmv; i++)
      if (mv.pc.turn ? dist[mv.i]<dist[mvs[i].i] : dist[mv.i]>dist[mvs[i].i])
        break;
    for (j=nmv++; j>i; j--)
      mvs[j]=mvs[j-1];
    mvs[i]=mv;
  }
}

uint genmoves(pcs pc) {
  pc.turn = !pc.turn;
  nmv = 0;
  mv.pc = pc;
  if (pc.turn) {
    uint wky = pc.wking/8, wkx = pc.wking%8;
    if (wkx>0 && wky>0) try(mv.pc.wking=pc.wking-9);
    if (         wky>0) try(mv.pc.wking=pc.wking-8);
    if (wkx<7 && wky>0) try(mv.pc.wking=pc.wking-7);
    if (wkx>0         ) try(mv.pc.wking=pc.wking-1);
    if (wkx<7         ) try(mv.pc.wking=pc.wking+1);
    if (wkx>0 && wky<7) try(mv.pc.wking=pc.wking+7);
    if (         wky<7) try(mv.pc.wking=pc.wking+8);
    if (wkx<7 && wky<7) try(mv.pc.wking=pc.wking+9);
    uint wferz = ferz(pc.wferz);
    uint wfy = wferz/8, wfx = wferz%8;
    mv.pc = pc; // restore wking
    if (wfx>0 && wfy>0) try(mv.pc.wferz=(wferz-9)>>1);
    if (wfx<7 && wfy>0) try(mv.pc.wferz=(wferz-7)>>1);
    if (wfx>0 && wfy<7) try(mv.pc.wferz=(wferz+7)>>1);
    if (wfx<7 && wfy<7) try(mv.pc.wferz=(wferz+9)>>1);
  } else {
    uint bky = pc.bking/8, bkx = pc.bking%8;
    if (bkx>0 && bky>0) try(mv.pc.bking=pc.bking-9);
    if (         bky>0) try(mv.pc.bking=pc.bking-8);
    if (bkx<7 && bky>0) try(mv.pc.bking=pc.bking-7);
    if (bkx>0         ) try(mv.pc.bking=pc.bking-1);
    if (bkx<7         ) try(mv.pc.bking=pc.bking+1);
    if (bkx>0 && bky<7) try(mv.pc.bking=pc.bking+7);
    if (         bky<7) try(mv.pc.bking=pc.bking+8);
    if (bkx<7 && bky<7) try(mv.pc.bking=pc.bking+9);
    uint bferz = ferz(pc.bferz);
    uint bfy = bferz/8, bfx = bferz%8;
    mv.pc = pc; // restore bking
    if (bfx>0 && bfy>0) try(mv.pc.bferz=(bferz-9)>>1);
    if (bfx<7 && bfy>0) try(mv.pc.bferz=(bferz-7)>>1);
    if (bfx>0 && bfy<7) try(mv.pc.bferz=(bferz+7)>>1);
    if (bfx<7 && bfy<7) try(mv.pc.bferz=(bferz+9)>>1);
  }
  return nmv;
}

int main() {
  imap im;
  uint nok=0, new=0, dtw=1;
  for (im.i=0; im.i<NBM; im.i++) {
    if (!ok(im.pc))
      continue;
    dist[im.i] = wins(im.pc) ? (new++,dtw) : fails(im.pc) ? FAIL : INF;
    nok++;
  }
  printf("%d ok\nfound %d at dtw %d\n", nok, new, dtw);
  for (;;) {
    dtw++;
    for (im.i=new=0; im.i<NBM; im.i++) {
      if (im.pc.turn==(dtw&1) || dist[im.i]!=INF)
        continue;
      uint i,nmoves = genmoves(im.pc);
      if (dtw&1) { // needs WTM
        for (i=0; i<nmoves; i++) {
          if (dist[mvs[i].i] < dtw) {
            dist[im.i] = dtw;
            new++;
            break;
          }
        }
      } else { // needs BTM
        for (i=0; i<nmoves; i++) {
          if (dist[mvs[i].i] >= INF)
            break;
        }
        if (i==nmoves) {
          dist[im.i] = dtw;
          new++;
        }
      }
    }
    printf("found %d at dtw %d\n", new, dtw);
    if (!new)
      break;
  }
  dtw--;
#ifdef SHOWMAX
  for (im.i=new=0; im.i<NBM; im.i++)
    if (dist[im.i]==dtw)
      show(im.pc);
#endif
  pcs diamondpc = {41,27,21,28,0};
  pcs toughpc = {24,7,1,28,0};
#ifdef PLAYROUGH
  im.pc = toughpc;
#else
  im.pc = diamondpc;
#endif
  for (;;) {
    uint i,nmoves = genmoves(im.pc);
    show(im.pc); printf("dist=%d %d moves\n\n", dist[im.i], nmoves);
    for (i=nmoves; i--; ) {
      printf("move %d dist %d\n", i, dist[mvs[i].i]);
      show(mvs[i].pc);
    }
    printf("\n");
    show(im.pc); printf("dist=%d %cTM %d moves\n", dist[im.i], "WB"[im.pc.turn], nmoves);
    do {
      printf("Enter move number (0-%d): ",nmoves-1);
      scanf("%d", &i);
    } while (i<0 || i>= nmoves);
    im = mvs[i];
#ifdef AUTORESPONSE
    nmoves = genmoves(im.pc);
    show(im.pc); printf("dist=%d %d moves\n", dist[im.i], nmoves);
    uint bestdist=0,besti=0;
    for (i=0; i<nmoves; i++) {
      if (dist[mvs[i].i] > bestdist)
        bestdist = dist[mvs[besti=i].i];
    }
    im = mvs[besti];
#endif
  }
  return 0;
}
