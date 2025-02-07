# Lab 2 Script: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Objectives ----
# In this Lab you will learn to:

# 1. Load datasets into your R session -> open the `Lab2_script.R` to go over in class.
# 2. Learn about the different ways `R` can plot information
# 3. Learn about the usage of the `ggplot2` package


#---- Part 1: Loading data ----

# Data can be loaded in a variety of ways. As always is best to learn how to load using base functions that will likely remain in time so you can go back and retrace your steps. 
# This time we will load two data sets in three ways.


## ---- Part 1.1: Loading data from R pre-loaded packages ----

data() # shows all preloaded data available in R in the datasets package
help(package="datasets")  # it opens the documentation for package"datasets" in help section 

#Let's us the Violent Crime Rates by US State data 

help("USArrests") #it shows the Violent Crime Rates by US State in help section 

# Step 1. Load the data in you session by creating an object

usa_arrests<-datasets::USArrests # this looks the object 'USAarrests' within '::' the package 'datasets'

class(usa_arrests) #it shows the class of "usa_arrets" which is "data.frame" 
names(usa_arrests) #it shows the names of each column in usa_arrests 
dim(usa_arrests) #it gives us the numbers of rows and columns in usa_arrests which is 50 rows and 4 columns  
head(usa_arrests) #it shows us the first 6 rows with its data  
tail(usa_arrests) #it shows us the last 6 rows with its data  

## ---- Part 1.2: Loading data from your computer directory ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa<-read.csv(file = "datasets/accelaissuedpermitsextract.csv",header = T)   #it calls the building_permits_sa file from the file location 

names(building_permits_sa) #it gives us the names of the columns in building_permits_sa
View(building_permits_sa) # it shows or opens the data in a window
class(building_permits_sa) #it shows the class of building_permits_sa which is "data.frame" 
dim(building_permits_sa) #it gives us the numbers of rows and columns in building_permits_sa which is 5232 rows and 16 columns 
str(building_permits_sa) # I did not understand this one but when I googled it it says "it used to display the internal structure of an object"  
summary(building_permits_sa) #it gives us a summary of each column in building_permits_sa  


## ---- Part 1.3: Loading data directly from the internet ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa2 <- read.csv("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/accelaissuedpermitsextract.csv",header = T) # Load the file from the internet or the written link  




## ---- Part 1.4: Loading data using a package + API ----
#install.packages("tidycensus")
#install.packages("tigris")
help(package="tidycensus") #it opens the help Documentation  in help section  
library(tidycensus) #Load the library tidycensus 
library(tigris) #Load the library tigris  


#type ?census_api_key to get your Census API for full access.
census_api_key("0d539976d5203a96fa55bbf4421110d4b3db3648", overwrite = TRUE)  #this is my census_api_key to get access for  


age10 <- get_decennial(geography = "state", 
                       variables = "P013001", 
                       year = 2010) #it retrieves median age for each state for the year 2010  

head(age10)  #it shows the first 6 rows with its data  


bexar_medincome <- get_acs(geography = "tract", variables = "B19013_001",
                           state = "TX", county = "Bexar", geometry = F) #Retrieve median household income for Bexar County with out geometry  


View(bexar_medincome) #it opens the bexar_medincome in a window   

class(bexar_medincome) #it shows the class of bexar_medincome which are "tbl_df"     "tbl"        "data.frame" 

#---- Part 2: Visualizing the data ----
#install.packages('ggplot2')

library(ggplot2) #load ggplot2 library for Visualizing the data 



## ---- Part 2.1: Visualizing the 'usa_arrests' data ----

ggplot() # it create an empty map on plots window 

#scatter plot - relationship between two continuous variables
ggplot(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) +
  geom_point() # it create a scatter plot between x=Assault,y=Murder

ggplot() +
  geom_point(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) #same as line 101 but a new method 


#bar plot - compare levels across observations
usa_arrests$state<-rownames(usa_arrests) # it creates a new column called state in  usa_arrests 

ggplot(data = usa_arrests,aes(x=state,y=Murder))+
  geom_bar(stat = 'identity') # It creates a bar graph between x=state,y=Murder 

ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder))+
  geom_bar(stat = 'identity')+
  coord_flip() #it creates bar graph between (state and Murder) vs Murder 

# adding color # would murder arrests be related to the percentage of urban population in the state?
ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder,fill=UrbanPop))+
  geom_bar(stat = 'identity')+
  coord_flip()

# adding size
ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()  ## Scatter plot with point size that represent urban population



# plotting by south-east and everyone else 

usa_arrests$southeast<-as.numeric(usa_arrests$state%in%c("Florida","Georgia","Mississippi","Lousiana","South Carolina")) #it creates a new column in usa_arrests that categorize these states "Florida","Georgia","Mississippi","Lousiana","South Carolina" 


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop, color=southeast)) +
  geom_point()

usa_arrests$southeast<-factor(usa_arrests$southeast,levels = c(1,0),labels = c("South-east state",'other'))  #it categorize the state if 1 it would be south-east state , if 0 it would be other 

ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_wrap(southeast~ .)  #it creates a scatter plot that sapreates between south-east and others  


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_grid(southeast ~ .) #same as 139 but in a different method 

## ---- Part 3: Visualizing the spatial data ----
# Administrative boundaries


library(leaflet)
library(tigris)

bexar_county <- counties(state = "TX",cb=T)
bexar_tracts<- tracts(state = "TX", county = "Bexar",cb=T)
bexar_blockgps <- block_groups(state = "TX", county = "Bexar",cb=T)
#bexar_blocks <- blocks(state = "TX", county = "Bexar") #takes lots of time


# incremental visualization (static)

ggplot()+
  geom_sf(data = bexar_county)

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])+
  geom_sf(data = bexar_tracts)

p1<-ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",],color='blue',fill=NA)+
  geom_sf(data = bexar_tracts,color='black',fill=NA)+
  geom_sf(data = bexar_blockgps,color='red',fill=NA)

ggsave(filename = "02_lab/plots/01_static_map.pdf",plot = p1) #saves the plot as a pdf



# incremental visualization (interactive)

#install.packages("mapview")
library(mapview)

mapview(bexar_county)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)+
  mapview(bexar_blockgps)


#another way to vizualize this
leaflet(bexar_county) %>%
  addTiles() %>%
  addPolygons()

names(table(bexar_county$NAME))

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons()

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups")

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups") %>%
  addLayersControl(
    overlayGroups = c("county", "tracts","block groups"),
    options = layersControlOptions(collapsed = FALSE)
  )



