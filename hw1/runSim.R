## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

getMSE <- function(x, total) {
  mean <- 0
  mse <- sum((x-mean)^2)/total
  return(mse)
}

# simulate data
set.seed(seed)
if (dist=="gaussian"){
  x <- replicate(rep,rnorm(n))
}else if(dist=="t1"){
  x <- replicate(rep,rt(n,1))
}else{
  x <- replicate(rep,rt(n,5))
}

paste('primed-indexed average:', apply(x,2,estMeanPrimes))
print('primed-indexed average MSE:')
print(getMSE(apply(x,2,estMeanPrimes), rep))
paste('classical sample average:', colMeans(x))
print('classical sample average MSE:')
print(getMSE(colMeans(x), rep))
