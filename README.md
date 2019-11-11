## Overview of problem

When I worked in subprime auto-lending, we had two types of borrowers.  One type would make every effort to pay, but would often default due to unforseen financial circumstances.  The second type had no intention to repay and would default in the first 1-3 months of the loan.  

When viewing a histogram of default times, there was clearly a bi-modal distribution.  This bi-modal distribution was demonstrative of the two types of borrowers.  However, there is no clear or obvious labeled segmentation.  Sometimes a borrower would not intent to pay but would make a few payments in order to avoid repo for a set time.  Sometimes a borrower who did intent to pay had a life event immediately after purchase that cause immediate default.

This type of problem is a latent-variable problem which can be solved using expectation-maximization techniques.  In this repository, I demonstrate the e-m alogirthm on simulated data from a mixture of two exponential distributions.  

## Problem assumptions

There are two distributions of individuals: those that want to repay, and those that don't want to repay.  The times to default for both are exponentially distributed, but the parameter for the first group is much smaller than for the second (indicating more willingness to repay).  

## Mathematical formulation

Many of the lecture notes I reviewed seemed to overcomplicate the problem.  I wrote the derivation in as concise a form as possible in [E-M Derivation](./explanation.pdf)

## Results

I get very close results to the R package mixtools.  

I was surprised how sensitive the results were to 
* the original parameters (the algorithm can even become "stuck", try initial parameters of `lambda=c(0.27, 0.27)` and `alpha=c(0.5, 0.5)`)
* the algorithm (in)efficiency when the rate parameters for the exponential distribution become closer together.  This was true even when using rates of 0.5 and 0.2 (which are comparatively far apart).  For comparison, try initial parameters of `lambda=c(.3734954 0.1734954)` and `alpha=c(0.4, 0.6)` with two different simualted parameters: `lambda_real=c(1.5, 0.2)` and `lambda_real=c(0.5, 0.2)`

## Acknowledgments

The goal of this project was 
* to get more familiar with E-M
* to conceptually resolve and issue I've tried to model with subprime data

Since this was a continuously learning exercise, I read quite a few articles online on E-M.  Two that were particularly helpful (and one of which I copied much of the code from) are:
* http://www.svcl.ucsd.edu/courses/ece271A/handouts/EM2.pdf
* http://tinyheero.github.io/2016/01/03/gmm-em.html#parameter-estimation-in-the-complete-data-scenario

And a third that gave a more rigorous mathematical rationale for E-M:
* https://www.stat.cmu.edu/~cshalizi/350/lectures/29/lecture-29.pdf