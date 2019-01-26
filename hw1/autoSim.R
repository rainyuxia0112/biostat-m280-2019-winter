## parsing command arguments
for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

nVals <- seq(100, 500, by=100)
for (n in nVals) {
  for (dist in c("\\'gaussian\\'", "\\'t5\\'", "\\'t1\\'")){
    oFile <- paste("n", n, ".txt", sep="")
    sysCall <- paste("nohup Rscript runSim.R n=", n, " seed=", seed, " dist=", dist, " rep=", rep, " >> ", oFile, sep="")
    system(sysCall)
    print(paste("sysCall=", sysCall, sep=""))
  }
}