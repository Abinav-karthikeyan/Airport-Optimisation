setwd("C:\\Users\\abhin\\OneDrive\\Documents\\Course Content\\Prescriptive Analytics")
paris_data = read.csv("C:\\Users\\abhin\\OneDrive\\Documents\\Course Content\\Prescriptive Analytics\\fwc.csv")

View(paris)

library(tidygeocoder)
library(dplyr)
library(geodist)

paris%>%geocode()



paris = paris_data[,c(30,37,38,39,50,56,57,58,68,71)]

paris$Capacity =  as.numeric(paris$Capacity)

paris = na.omit(paris)

View(paris)

paris$expected_arrivals = round(paris$Capacity * 0.9)

paris$airport_add = paste(paris$origin.name, paris$origin.city, sep = "," )

paris$airport_add = gsub("Int'l", "International", paris$airport_add)

View(paris)

for (i in 1:nrow(paris)) {
  # Use the geocode function to get latitude and longitude for each row
  
  paris$airport_add[i] = gsub("Int'l", "Internations", paris$airport_add[i])
    
  t <- paris[i,] %>% geocode(airport_add)
  
  # Check if both latitude and longitude are missing
  if (is.na(t$lat)) {
    # If missing, try geocoding with 'origin.city'
    t <- paris[i,] %>% geocode(origin.city)
  }
  
  # Update the values in the 'paris' data frame
  paris$latitude[i] <- t$lat
  paris$longitude[i] <- t$long
  
}

paris = paris[!duplicated(paris$scheduled_on),]

paris$country = c(" ")

for (i in 1:nrow(paris)) {
  
f = paris[i,] %>% reverse_geocode(lat = latitude, long = longitude, method = 'osm',custom_query  = list("accept-language"="en"))
paris$country[i] = tail(strsplit(f$address, ",")[[1]],1)
  
}

scheng = read.csv("C:\\Users\\abhin\\OneDrive\\Documents\\Course Content\\Prescriptive Analytics\\Project\\scheng.csv")

scheng_countries = c(scheng$Country)

scheng

typeof(scheng_countries)

paris = na.omit(paris)

paris <- paris %>%
  mutate(
    is_Scheng = ifelse(grepl(paste(scheng_countries, collapse = "|"), as.character(country), ignore.case = TRUE), "Yes", "No")
  )

View(paris)


paris$arrival_time = c(0)

for (i in 1:nrow(paris))
{  
  
datetime <- as.POSIXct(paris$scheduled_on[i], format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
paris$arrival_time[i]= format(datetime, format = "%H:%M:%S")

}


library(leaflet)

paris$schengcolor = ifelse(paris$is_Scheng == "Yes" , "Blue", "Red")

schengcolor = ifelse(paris$is_Scheng == "Yes" , "Blue", "Red")




start_point = c("City" = "Paris","latitide" = 49.00781744550195 , "longitude" = 2.550835869547012)

airport_locs = data.frame("City" = paris$origin.city , "latitude" = paris$latitude , "longitude"= paris$longitude)

airport_locs = rbind( start_point,airport_locs)

View(airport_locs)

airport_locs$latitude = as.numeric(airport_locs$latitude)
airport_locs$longitude = as.numeric(airport_locs$longitude)

schengcolor[3]

pairs <- expand.grid(
  from = 2:nrow(airport_locs),
  to = 1
)

pairs

str(airport_locs)

map  = leaflet(paris) %>% addTiles() %>% addCircleMarkers(color = ~factor(schengcolor), radius = 0.5)%>% 
  addCircleMarkers(lat = 49.00781744550195, lng = 2.550835869547012 , color = "black", radius = 2)

for(i in 2:nrow(airport_locs))
{
map= map %>%
  addPolylines(
    lat = c(airport_locs[i, "latitude"], airport_locs[1, "latitude"]),
    lng = c(airport_locs[i, "longitude"], airport_locs[1, "longitude"]),
    color = schengcolor[i-1],
    weight = 1
  )
  
}

map%>% 
  addCircleMarkers(lat = 49.00781744550195, lng = 2.550835869547012 , color = "black", radius = 2)%>%
  addLegend(
    position = "bottomright",
    colors = unique(as.character(schengcolor)),
    labels = unique(as.character(paris$is_Scheng)),
    title = "Schengen Countries"
  )



paris$arrival_time = as.POSIXct(paris$arrival_time, format = "%H:%M:%S")

start_time <- as.POSIXct("15:00:00", format = "%H:%M:%S")
end_time <- as.POSIXct("15:30:00", format = " %H:%M:%S")



paris_peak <- paris %>% filter(arrival_time >= start_time, arrival_time <= end_time)

View(paris_peak)

paris <- paris[order(paris$arrival_time),]

library(dplyr)


# Assuming "arrival_time" is a character vector in the format "HH:MM:SS"
paris$arrival_time <- as.POSIXlt(paris$arrival_time, format = "%H:%M:%S", tz = "UTC")
paris$arrival_time = format()

as.numeric(paris$arrival_time[1])

paris$arrival_time[1]

paris$arrnum = as.numeric(paris$arrival_time)

paris <- paris %>%
  mutate(Period = case_when(
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 10:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 11:00:00 UTC"))) ~ "Period 1",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 11:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 12:00:00 UTC"))) ~ "Period 2",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 12:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 13:00:00 UTC"))) ~ "Period 3",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 13:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 14:00:00 UTC"))) ~ "Period 4",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 14:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 15:00:00 UTC"))) ~ "Period 5",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 15:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 16:00:00 UTC"))) ~ "Period 6",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 16:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 17:00:00 UTC"))) ~ "Period 7",
    between(arrnum, as.numeric(as.POSIXct("2023-11-30 17:00:00 UTC")), as.numeric(as.POSIXct("2023-11-30 18:00:00 UTC"))) ~ "Period 8",
    TRUE ~ NA_character_
  ))


paris%>%aggregate()
print(class(paris$arrival_time))

aggregated_data <- paris %>%
  group_by(Period) %>%
  summarize(total_arrivals = sum(expected_arrivals, na.rm = TRUE))

aggregated_data$total_arrivals = round(aggregated_data$total_arrivals * 0.715,0)

View(aggregated_data)

View(paris_peak)

library(plotly)

line_plot <- plot_ly(aggregated_data, x = ~Period, y = ~total_arrivals, type = 'scatter', mode = 'lines+markers')

# Add layout options
line_plot <- line_plot %>% layout(
  title = "Aggregated Arrivals Plot",
  xaxis = list(title = "Period (1 hour each)"),
  yaxis = list(title = "Total Passenger Arrivals")
)

# Specify coordinates for annotations
annotation_coords <- list(
  x = aggregated_data$Period[1], 
  y = aggregated_data$total_arrivals[1], 
  text = "Start"
)

# Add annotations
line_plot <- line_plot %>% add_annotations(annotation_coords)


library(ggplot2)

# Assuming you have a data frame called aggregated_data
# with columns 'Period' and 'total_arrivals'
# Replace these with your actual column names

# Create a ggplot
gg_line_plot <- ggplot(aggregated_data, aes(x = Period, y = total_arrivals)) +
  geom_line(color = "red", group =1) +
  geom_point(color = "blue") +
  labs(title = "Aggregated Arrivals Plot For Schengen and Non-Schenger Class Passengers ", x = "Period (1 hour each)", y = "Total Passenger Arrivals")

# Specify coordinates for annotations
annotation_coords <- data.frame(
  Period = aggregated_data$Period[5],
  total_arrivals = aggregated_data$total_arrivals[6]-10,
  label = "Bottle-Neck Period"
)

# Add annotations
gg_line_plot <- gg_line_plot +
  geom_text(data = annotation_coords, aes(label = label), vjust = -0.5, hjust = -0.5)

# Print the plot
print(gg_line_plot)




df_alloc = data.frame("Slot" = c("Slot1","Slot2","Slot3","Slot4","Slot5","Slot6"),
                      "Schengen Allocation" = c(128,80,214,81,134,104),
                      "Non Schengen Allocation" = c(117,165,56,239,166,92))

fig <- df_alloc %>% plot_ly()
fig <- fig %>% add_trace(x = ~Slot, y = ~Schengen.Allocation, type = 'bar', name = "Schengen",
                         text = df_alloc$Schengen.Allocation, textposition = 'auto',
                         marker = list(color = 'rgb(158,202,225)',
                                       line = list(color = 'rgb(8,48,107)', width = 1.5)))

fig <- fig %>% add_trace(x = ~Slot, y = ~Non.Schengen.Allocation, name = "Non-Schengen", type = 'bar',  # Fix here
                         text = df_alloc$Non.Schengen.Allocation, textposition = 'auto',
                         marker = list(color = 'rgb(58,200,225)',
                                       line = list(color = 'rgb(8,48,107)', width = 1.5)))
fig <- fig %>% layout(title = "Optimal Allocation according to Slots and Categories",
                      barmode = 'group',
                      xaxis = list(title = "Slots"),
                      yaxis = list(title = "Passenger Count"))

fig




# Print the plot
print(line_plot)

sum(paris_peak$expected_arrivals)/2

View(paris_peak)

belts = read.csv("belts.csv")

head(belts)

colnames(belts) = c("Bay", "Latitude","Longitude")

belts_dist = geodist(belts)

write.csv(belts_dist, "Distance_matrix_CDG.csv")

colnames(belts_dist) = row.names(belts_dist) = belts$Bay

View(paris_data)
