#
# --- mathematics ---
#

# harmonic mean
# !!! what's with all these negatives?

harmonic.mean <- function(x)
{
  -(-log(length(x)) + log.sum(-x))
}


# exchangeable dirichlet likelihood

exch.dirichlet.lhood <- function(counts, hyper)
{
  #print ("inside likelihood calcultion function")
  #print(dim(counts))
  k <- length(counts)
  idx <- counts > 0
  #print (k)
  #print("printing counts idx")
  #print (counts[idx])
  v <- (lgamma(k*hyper) - sum(idx)*lgamma(hyper) +
        sum(lgamma(hyper+counts[idx])) - lgamma(sum(counts[idx])+k*hyper))

#v <- 0.1
 v 
}


dirichlet.lhood <- function(counts, alpha)
{
  k <- length(counts)
  idx <- counts > 0
  v <- (lgamma(sum(alpha)) -
        sum(lgamma(alpha[idx])) +
        sum(lgamma(alpha[idx] + counts[idx])) -
        lgamma(sum(counts)+sum(alpha)))

  v
}

# draw from a dirichlet

rdirichlet <- function(n, alpha)
{
  l <- length(alpha)
  x <- matrix(rgamma(l * n, alpha), ncol = l, byrow = TRUE)
  sm <- x %*% rep(1, l)
  x/as.vector(sm)
}


# the logistic function

logistic <- function(x) exp(x) / (1 + exp(x))


# given log(v), returns log(sum(v))

log.sum <- function(v) {

  log.sum.pair <- function(x,y)
  {
    if ((y == -Inf) && (x == -Inf))
    { return(-Inf); }
    if (y < x) return(x+log(1 + exp(y-x)))
    else return(y+log(1 + exp(x-y)));
  }
  if (length(v) == 1)
    return(v)
  r <- v[1];
  for (i in 2:length(v))
    r <- log.sum.pair(r, v[i])
  return(r)
}


# liu's alpha identity

liu <- function(a, n)
{
  sum(sapply(1:n, function (i) a/(a + i - 1)))
}


# --- other ---

msg <- function(s, ...)
{
  time <- format(Sys.time(), "%X")
  cat(sprintf("%s | %s\n", time, s))
}

char <- as.character

colsum <- function (x)
{
  if (is.null(dim(x)) || (dim(x)[1] == 1))
    x
  else
    colSums(x)
}

# safe log function: smoothly handles zero and infinity

safelog <- function (x) {

  safelog.f <- function (x)
      #print (x)
      if (x == Inf)
        Inf
      else if (x == 0)
        -100
      else
        log(x)

  if (length(x) == 1)
    safelog.f(x)
  else
    sapply(x, safelog.f)
}


# returns customers that are connected to i, directly or indirectly

connections <- function(i, links)
{
  visited <- c()
  to.visit <- c(i)
  while (length(to.visit) > 0) {
    curr <- to.visit[1]
    visited <- c(visited, curr)
    to.visit <- to.visit[-1]
    pointers <- which(links == curr)
    for (p in pointers) {
      if (!(p %in% visited))
        to.visit <- c(to.visit, p)
    }
  }
  visited
}


# example ddcrp summary functions

ncomp.summary <- function(dat, iter, state, lhood, alpha)
{
  c(iter = iter, ncomp = length(unique(state$cluster)))
}

crp.score.summary <- function(dat, iter, state, lhood, alpha)
{
  c(iter = iter,
    ncomp = length(unique(state$cluster)),
    crp.score = (crp.log.prior(alpha, state$cluster) + sum(lhood)))
}