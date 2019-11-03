## Overview of problem

When I worked in subprime auto-lending, we had two types of borrowers.  One type would make every effort to pay, but would often default due to unforseen financial circumstances.  The second type had no intention to repay and would default in the first 1-3 months of the loan.  

When viewing a histogram of default times, there was clearly a bi-modal distribution.  This bi-modal distribution was demonstrative of the two types of borrowers.  However, there is no clear or obvious labeled segmentation.  Sometimes a borrower would not intent to pay but would make a few payments in order to avoid repo for a set time.  Sometimes a borrower who did intent to pay had a life event immediately after purchase that cause immediate default.

This type of problem is a latent-variable problem which can be solved using expectation-maximization techniques.  In this repository, I demonstrate the e-m alogirthm on simulated data from a mixture of two exponential distributions.  

## Problem assumptions

There are two distributions of individuals: those that want to repay, and those that don't want to repay.  The times to default for both are exponentially distributed, but the parameter for the first group is much smaller than for the second (indicating more willingness to repay).  