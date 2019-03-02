library(readr)
library(tidyverse)
library(reshape2)
library(plotly)
library(ggpubr)
library(gridExtra)

original <- read_csv("/home/m280data/la_payroll/City_Employee_Payroll.csv")


# Q2
yrs <- unique(original$Year) # all years
pay <- c()
for(yr in yrs) { # subset and sum
  pay_yr <- filter(original ,Year == yr) %>%
    select(`Base Pay`, `Overtime Pay`, `Other Pay (Payroll Explorer)`)
  pay_yr <- sapply(pay_yr, function(x) sum(x, na.rm = T))
  new_row <- c(yr, unlist(pay_yr))
  pay <- rbind(pay, new_row)
}
df_year <- data.frame(pay)
colnames(df_year) <- c("Year", "Base Pay", "Overtime Pay", "Other Pay")
saveRDS(df_year, "/home/xiayu960112/biostat-m280-2019-winter/hw3/LA-City-Payroll/TotalPayroll.RDS")

# Q3
df_employee <- within(original,  Person <- paste(`Department Title`, `Job Class Title`, sep=": ")) # new column for identification
df_employee <- df_employee[order(-df_employee$`Total Payments`),] #sort
df_employee <- df_employee %>%
  select(`Year`, `Total Payments`, `Base Pay`, `Overtime Pay`, `Other Pay (Payroll Explorer)`, `Person`)
colnames(df_employee) <- c("Year", "Total", "Base Pay", "Overtime Pay", "Other Pay", "Person")
saveRDS(df_employee, "/home/xiayu960112/biostat-m280-2019-winter/hw3/LA-City-Payroll/EmployeePayroll.RDS")

# Q4 and Q5
departments <- unique(original$`Department Title`)
df_department <- c()
for(department in departments) {
  for(yr in yrs) {
    sum <- original %>%
      filter(`Department Title` == department & Year == yr) %>%
      select(`Average Benefit Cost`,`Total Payments`, `Base Pay`, `Overtime Pay`, `Other Pay (Payroll Explorer)`) %>%
      sapply(function(x) sum(x, na.rm = T))
    r <- c(department, yr, unlist(sum))
    df_department <- rbind(df_department, r)
  }
}
df_department <- data.frame(df_department, stringsAsFactors=FALSE)
df_department[,3:7] <- sapply(df_department[,3:7], function(x) as.numeric(as.character(unlist(x))))
df_department <- df_department[order(-df_department$Total.Payments),]
colnames(df_department) <- c("Department", "Year", "Cost","Total", "Base Pay", "Overtime Pay", "Other Pay")
saveRDS(df_department, "/home/xiayu960112/biostat-m280-2019-winter/hw3/LA-City-Payroll/DepartmentPayroll.RDS")
df_department_cost <- df_department[order(-df_department$Cost),]
saveRDS(df_department_cost, "/home/xiayu960112/biostat-m280-2019-winter/hw3/LA-City-Payroll/DepartmentPayrollCost.RDS")

# Q6
df_full <- original %>%
  select(Year, `Employment Type`)
colnames(df_full) <- c("Year", "Employment Type")
saveRDS(df_full, "/home/xiayu960112/biostat-m280-2019-winter/hw3/LA-City-Payroll/EmploymentType.RDS")
