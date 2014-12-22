This literatare Haskell program demonstrates how Higher Order Abstract Syntax (HOAS) allows for very simple step-wise evaluation in the untyped lambda calculus.

> module HOAS where
> import Text.PrettyPrint.HughesPJ(Doc,render,text,(<+>),parens)
> import Data.Maybe(Maybe,fromJust)
> import Control.Monad(mplus)
> import Data.List(unfoldr)
> import Data.Char(ord,chr)

A term is either an abstraction, represented by a Haskell function binding a variable identifier, an application, or a variable binding depth (Bound At Depth).

> data HOAS = Lam (HOAS -> HOAS) | App HOAS HOAS | BAD Int

BAD is used only for converting terms, not for representing them.
The identity function is simply represented as

> i :: HOAS
> i = Lam(\x-> x)

and the two basis functions in combinatory logic as

> k :: HOAS
> k = Lam(\x-> Lam(\y-> x))
> s :: HOAS
> s = Lam(\x-> Lam(\y-> Lam(\z-> (x `App` z) `App` (y `App` z))))

Evaluation to normal form is a simple matter of evaluating the body in an abstraction,
both the function and argument in an application, and applying the representing Haskell
function when the former evaluates to an abstraction, which will perform substitution
without all the usual headaches, like free variable capture, of a classical representation.

> nf :: HOAS -> HOAS
> nf (Lam f)   = Lam (nf . f)
> nf (App f a) = case nf f of { Lam g -> g; g -> App g } $ nf a
> nf x         = x

Performing individual beta reduction steps is almost as easy,
only complicated by the need to determine if an abstraction body has a redex:

> step :: HOAS -> Maybe HOAS
> step (App (Lam f) a) = Just $ f a
> step (App f       a) = fmap (`App` a) (step f) `mplus` fmap (f `App`) (step a)
> step (Lam f)         = step (f (BAD undefined)) >> Just (Lam (fromJust . step . f))
> step _               = Nothing

Combining steps by unfolding

> steps :: HOAS -> [HOAS]
> steps = unfoldr (fmap (\x->(x,x)) . step)

gives us an alternative way to derive normal forms as

> slownf :: HOAS -> HOAS
> slownf = last . steps

It remains to show off the fruits of our efforts with a pretty printer

> par :: Bool -> Doc -> Doc
> par b = if b then parens else id
> instance Show HOAS where
>   show = render . pp 0 0 where
>     pp d p t = case t of
>       Lam f   -> par (p>0) $ text ('\\':var d) <+> pp (succ d) 0 (f (BAD d))
>       App f a -> par (p>1) $ pp d 1 f <+> pp d 2 a
>       BAD v   -> text $ var v
>     var   = return . chr . (ord 'a' +) -- assume depth <= 26

Example reduction of predecessor of Church numeral one

> prd = Lam(\n->Lam(\f->Lam(\x->n`App`Lam(\g->Lam(\h->h`App`(g`App`f)))`App`Lam(\u->x)`App`i)))
> example1 = prd `App` i

Infinite reduction

> dbl = Lam (\x -> x `App` x)
> example2 = dbl `App` dbl

Ackermann

> ack = Lam(\n->n`App`Lam(\f->Lam(\m->f`App`(m`App`f`App`i)))`App`Lam(\m->Lam(\f->Lam(\x->f`App`(m`App`f`App`x))))`App`n)
> two = Lam(\f->Lam(\x->f`App`(f`App`x)))
> example3 = ack `App` two

> showoff :: HOAS -> IO ()
> showoff = mapM_ print . steps

> main = showoff example1

This gives the output:

\a \b (\c c) (\c \d d (c a)) (\c b) (\c c)
\a \b (\c \d d (c a)) (\c b) (\c c)
\a \b (\c c ((\d b) a)) (\c c)
\a \b (\c c) ((\c b) a)
\a \b (\c b) a
\a \b b

One downside is that variable names do not preserve identity between steps,
and only indicate binding depth.

Conversion from and to first order representation using De Bruijn indices

> data DB = DBLam DB | DBApp DB DB | DBVar Int deriving (Eq)

> instance Show DB where
>   show = render . pp 0 0 where
>     pp d p t = case t of
>       DBLam f   -> par (p>0) $ text "\\" <+> pp (succ d) 0 f
>       DBApp f a -> par (p>1) $ pp d 1 f <+> pp d 2 a
>       DBVar v   -> text $ show v

> fromDB :: DB -> HOAS
> fromDB = cnvt [] where
>   cnvt e t = case t of
>     DBLam f   -> Lam $ \x -> cnvt (x:e) f
>     DBApp f a -> App (cnvt e f) (cnvt e a)
>     DBVar i   -> e!!i

> toDB :: HOAS -> DB
> toDB = cnvt 0 where
>   cnvt d t = case t of
>     Lam f   -> DBLam . cnvt d' . f $ BAD d' where d' = succ d
>     App f a -> DBApp (cnvt d f) (cnvt d a)
>     BAD d'  -> DBVar $ d-d'

De Bruijn reduction with mapM_ (print . toDB) . steps $ example1

\ \ (\ 0) (\ \ 0 (1 3)) (\ 1) (\ 0)
\ \ (\ \ 0 (1 3)) (\ 1) (\ 0)
\ \ (\ 0 ((\ 2) 2)) (\ 0)
\ \ (\ 0) ((\ 1) 1)
\ \ (\ 1) 1
\ \ 0
