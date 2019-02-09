#include <Rcpp.h>
#include <iostream>
using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
void FizzBuzz(vector<int> & input){
  for(unsigned i = 0; i < input.size(); i++){
    if(input[i] % 15 == 0){
      Rcout << "FizzBuzz" << endl;
    }
    else if(input[i] % 3 == 0){
      Rcout << "Fizz" << endl;
    }
    else if(input[i] % 5 == 0){
      Rcout << "Buzz" << endl;
    }
    else if(input[i] % 5 == 0){
      Rcout << "Buzz" << endl;
    }
    else{
      Rcout << input[i] << endl;
    }
  }
}
// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

