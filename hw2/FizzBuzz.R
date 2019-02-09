for (arg in commandArgs(T)) {
  eval(parse(text = arg))
}

fizzbuzz <- function (x) {
  if(sum(sapply(x, function(a) return(is.numeric(a)))) == length(x)){
    if(sum(sapply(x, function(a) return(a%%1 == 0))) == length(x)){
      for(int in x){
        if(int %% 5 == 0 & int %% 3 == 0){
          cat("FizzBuzz", "\n", sep = "")
        }else if(int %% 5 == 0){
          cat("Buzz", "\n", sep = "")
        }else if(int %% 3 == 0){
          cat("Fizz", "\n", sep = "")
        }else{
          cat(int, "\n", sep = "")
        }
      }
    }else{
      print("Please use a scalar or an integer vector as your input!")
    }
  }else{
    print("Please use a scalar or an integer vector as your input!")
  }
}

fizzbuzz(x)
