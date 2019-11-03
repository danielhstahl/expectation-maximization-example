## Shamelessly stolen from http://tinyheero.github.io/2016/01/03/gmm-em.html
## and http://www.svcl.ucsd.edu/courses/ece271A/handouts/EM2.pdf
require(mixtools)

#' Expectation Step of the EM Algorithm
#'
#' Calculate the posterior probabilities (soft labels) that each component
#' has to each data point.
#'
#' @param lambda.vector Vector containing the "lambdas" of each component
#' @param alpha.vector Vector containing the mixing weights  of each component
#' @return Named list containing the loglik and posterior.df
e_step <- function(x, lambda.vector, alpha.vector) {
  comp.prod.vector <- sapply(mapply(c, lambda.vector, alpha.vector, SIMPLIFY=FALSE), function(l_a){
      dexp(x, l_a[1])*l_a[2]
  })
  sum.of.comps <- apply(comp.prod.vector, 1, function(category){
      sum(category)
  })
  ## this is h_{i,j}
  comp.post.vector <- sapply(c(1:length(lambda.vector)), function(index){
      comp.prod.vector[, index]/sum.of.comps
  })
  loglik <- sum(log(sum.of.comps))
  posterior <- comp.post.vector
  list("loglik"=loglik, "posterior.df"=posterior)
}

#' Maximization Step of the EM Algorithm
#'
#' Update the Component Parameters
#'
#' @param x Input data.
#' @param posterior.df Posterior probability data.frame.
#' @return Named list containing the lambda (lambda) and mixing
#'   weights (alpha) for each component.
m_step <- function(x, posterior.df) {
  comp.n.vector <- apply(posterior.df, 2, sum)
  comp.lambda.vector=sapply(c(1:length(comp.n.vector)), function(index){
    comp.n.vector[index]/(sum(posterior.df[, index]*x))
  })
  total.comp.n=sum(comp.n.vector)
  comp.alpha.vector=comp.n.vector/total.comp.n

  list("lambda" = comp.lambda.vector,
       "alpha" = comp.alpha.vector)
}

alpha_real=c(0.3, 0.7)
lambda_real=c(1.5, 0.2)
n=10000
realization_alpha=rbinom(n, 1, alpha_real[1])
realization_data=sapply(realization_alpha, function(indicator){
  if(indicator==1){
    rexp(1, lambda_real[1])
  }
  else{
    rexp(1, lambda_real[2])
  }
})

init_lambda=1/mean(realization_data)

for (i in 1:10000) {
  if (i == 1) {
    # Initialization
    e.step <- e_step(realization_data, c(init_lambda+.1, init_lambda-.1), c(0.4, 0.6))
    m.step <- m_step(realization_data, e.step[["posterior.df"]])
    cur.loglik <- e.step[["loglik"]]
    loglik.vector <- e.step[["loglik"]]
  } else {
    # Repeat E and M steps till convergence
    e.step <- e_step(realization_data, m.step[["lambda"]], 
                     m.step[["alpha"]])
    m.step <- m_step(realization_data, e.step[["posterior.df"]])
    loglik.vector <- c(loglik.vector, e.step[["loglik"]])

    loglik.diff <- abs((cur.loglik - e.step[["loglik"]]))
    if(loglik.diff < 1e-6) {
      break
    } else {
      cur.loglik <- e.step[["loglik"]]
    }
  }
}
#loglik.vector
print("--------------------")
print("actual")
print(paste("rate parameter:", lambda_real))
print(paste("probability:", alpha_real))

print("--------------------")
print("manual")
print(paste("rate parameter:", m.step$lambda))
print(paste("probability:", m.step$alpha))
print(paste("loglik:", loglik.vector[length(loglik.vector)]))

result=mixtools::expRMM_EM(realization_data, d=(0*realization_data+1),lambda=c(0.4, 0.6), k=2, rate=c(init_lambda+0.1, init_lambda-0.1), maxit=10000)
print("--------------------")
print("using built in package")
print(paste("rate parameter:", result$rate))
print(paste("probability:", result$lambda))
print(paste("loglik:", result$loglik))

