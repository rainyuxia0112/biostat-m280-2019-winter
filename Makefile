<<<<<<< HEAD
hw2sol: ./hw2/hw2sol.Rmd
  Rscript -e 'rmarkdown::render("$<")'
  
clean:
  rm -rf *.html *.md
=======
hw2sol: ./hw2/hw2sol.rmd
  Rscript -e 'rmarkdown::render("$<")'
  
>>>>>>> develop
