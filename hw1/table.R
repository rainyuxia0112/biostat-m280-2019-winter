library(readr)

txt_list <- c("n100.txt", "n200.txt", "n300.txt", "n400.txt", "n500.txt")
n_list <- list()
for (txt in txt_list) {
  n_list[[txt]] <- readLines(txt)
}

g <- c()
for(n in n_list) {
  g <- c(g, substring(n[52], first = 5))
  g <- c(g, substring(n[104], first = 5))
}
t5 <- c()
for(n in n_list) {
  t5 <- c(t5, substring(n[156], first = 5))
  t5 <- c(t5, substring(n[208], first = 5))
}
t1 <- c()
for(n in n_list) {
  t1 <- c(t1, substring(n[260], first = 5))
  t1 <- c(t1, substring(n[312], first = 5))
}

n <- c("100", "100", "200", "200", "300", "300", "400", "400", "500", "500")
method <- c("PrimeAvg", "SampAvg", "PrimeAvg", "SampAvg", "PrimeAvg", "SampAvg", "PrimeAvg", "SampAvg", "PrimeAvg", "SampAvg")
table <- data.frame(n, method, g, t5, t1)
print(table)
