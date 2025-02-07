# Lab 2 Assignment: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Instructions ----

# 1. [40 points] Open the R file "Lab2_Script.R" comment each line of code with its purpose (with exception of Part 3)
# 2. [60 points] Open the R file "Lab2_Assignment.R" and answer the questions

#---- Q1. write the code to load the dataset "tract_covariates.csv" located under the "datasets" folder in your repository. Create an object called `opportunities` Use the data.table package to do this. ----


#---- Q2. On your browser, read and become familiar with the dataset metadata. Next write the code for the following:
# Link to metadata: https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf 

# what is the object class?

# how can I know the variable names?

# What is the unit of analysis? 

# Use the `summary` function to describe the data. What is the variable that provides more interest to you?

# Create a new object called `sa_opportunities` that only contains the rows for the San Antonio area (hint: use the `czname` variable). 


# Create a plot that shows the ranking of the top 10 census tracts by Annualized job growth rate (`ann_avg_job_growth_2004_2013` variable) by census tract (tract variable). Save the resulting plot as a pdf with the name 'githubusername_p1.pdf' # Hint: for ordering you could use the `setorderv()` or reorder() functions, and the ggsave() function to export the plot to pdf. 

# Create a plot that shows the relation between the `frac_coll_plus` and the `hhinc_mean2000` variables, what can you hypothesize from this relation? what is the causality direction? Save the resulting plot as a pdf with the name 'githubusername_p3.pdf'

# Investigate (on the internet) how to add a title,a subtitle and a caption to your last plot. Create a new plot with that and save it as 'githubusername_p_extra.pdf'


#Q1 
library(data.table)


opportunities<-fread(file = "datasets/tract_covariates.csv",header = T)

# what is the object class?

class(opportunities)  #object class are "data.table" "data.frame"

# how can I know the variable names?
names(opportunities)  # we can know the names by using names() function

# What is the unit of analysis? 
#Ans: the unit of analysis is Census Tract as discriped in Neighborhood Characteristics by Census Tract also (A census tract in the United States has an 11-digit code) if we take czname = Winchester as an example we have 2 digits for state and 3 dgits for county tract 6 


# Use the `summary` function to describe the data. What is the variable that provides more interest to you?

summary(opportunities) #The variable ann_avg_job_growth_2004_2013 because it helps analyze economic trends and market performance. a higher rate shows economic growth while negative rate may show economic degrowth. 

head(opportunities)

library(dplyr)



sa_opportunities <- opportunities %>% filter(czname == "San Antonio")

top10_growth <- sa_opportunities[order(-sa_opportunities$ann_avg_job_growth_2004_2013), ][1:10, ]




githubusername_p1 <- ggplot(data = top10_growth, aes(x = reorder(tract, ann_avg_job_growth_2004_2013),
                                                     y = ann_avg_job_growth_2004_2013)) +
  geom_bar(stat = "identity")

print(githubusername_p1)

ggsave("githubusername_p1.pdf", width = 4, height = 4, githubusername_p1)



githubusername_p3 <- ggplot(data = sa_opportunities, aes(x = frac_coll_plus2010, y = hhinc_mean2000)) +
  geom_point(alpha = 0.6, color = "blue") 

print(githubusername_p3)
ggsave("githubusername_p3.pdf", width = 4, height = 4, githubusername_p3)



#The plot shows a positive relationship between education (frac_coll_plus2010) and income (hhinc_mean2000) areas with more college graduates tend to have higher household incomes.
#what is the causality direction?
#more education leads to better jobs and higher salaries


githubusername_p_extra <- ggplot(data = sa_opportunities, aes(x = frac_coll_plus2010, y = hhinc_mean2000)) +
  geom_point(alpha = 0.6, color = "blue") +
  labs(
    title = "Relationship Between Higher Education and Household Income",
    subtitle = "Scatter plot for the Relationship Between Higher Education and Household Income",
    caption = "Source: Census Bureau"
  )  

print(githubusername_p_extra)

ggsave("githubusername_p_extra.pdf", width = 4, height = 4, githubusername_p_extra)



#source https://youtu.be/N3vl7THgy0U?si=VH_r_soM3h32czCI 




