Visualization
-------------

Here is a chart showing movies that have passed/failed the Betchel Test
grouped by genre over the year 1970 to 2013

``` r
# Set Up Data

# Get the first genre listed 
movies <- movies %>% replace_na(list(genre = "None")) %>% mutate(firstG = word(genre, sep=","))
#movies$measure <- factor(movies$measure, levels = c("pass", "fail"))
movies %>% 
  filter(year > 1969) %>% 
  
  # Convert Pass/Fail indicator to ones and zeros to help count...
  mutate(pass = ifelse(binary=="PASS",1,0),fail = ifelse(binary=="FAIL",1,0)) %>%
  
  # Group by genre and count the pass, fails, and total...
  group_by(firstG) %>% 
  summarize(pass = sum(pass), fail = sum(fail)) %>% 
  mutate(total = pass + fail, PercentPass = pass/total) %>% 
  
  # Reshape the data for ggplot and filter out genres w/ small movie counts...
  pivot_longer(pass:total, names_to = "measure", values_to = "MoviesProduced") %>% 
  filter(measure != "total" & MoviesProduced > 1)  %>% 
  
  # Order factors based on movies count...
  mutate(firstG = fct_reorder(firstG, MoviesProduced, .desc = FALSE)) %>% 
  
  # Plot the data
  ggplot(aes(firstG, MoviesProduced, fill=measure)) +
  geom_bar(stat="identity",position = position_dodge(width = 0.8), width=0.7)+
  
  # Add a line as a visual q to help sepereate grouped bars 
  geom_vline(xintercept = seq(1.5,15.5, by=1), color="grey") +
  
  # Add the movie counts to the end of the bars...
  geom_text(aes(label=MoviesProduced), position = position_dodge(width = 0.8), hjust=-.7) +
  
  #Make it a horizontal bar chart
  coord_flip() +
  
  # Set up the labels, 
  ylab("Movie Count") + 
  xlab("Genre")+
  labs(
    title = "Bechdel Test by Genre", 
    subtitle = "The number of movies that pass and fail the Bechdel test filmed between 1970 and 2013", 
    caption = "Data Source: fivethirtyeight.com\nCreated By: @mwehinger") +
  
  # Set the colors & legend title,
  scale_fill_manual(values = c("orangered2","forestgreen"),name = "Bechtel Test") +
  
  
  # Adjust theme elements, 
  theme_ipsum_ps(grid="", axis_title_just = .5) + 
  theme(
    axis.ticks = element_blank(), 
    axis.line.y = element_blank(),
    axis.line.x = element_line(color="grey"),
    legend.position = c(.95, .1),legend.background = element_rect(fill = "white")) 
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

![](BechdelMovies_files/figure-markdown_github/Final%20Plot-1.png)

Exploratory Plots
-----------------

Other charts considered,

``` r
# Clean genre
movies <- movies %>% replace_na(list(genre = "None")) %>% mutate(firstG = word(genre, sep=","))

movies %>% filter(year > 1972) %>% mutate(pass = ifelse(binary=="PASS",1,0),fail = ifelse(binary=="FAIL",1,0)) %>% group_by(year) %>% summarize(pass = sum(pass), fail = sum(fail)) %>% mutate(total = pass + fail, PercentPass = pass/total) %>% ggplot(aes(x=year)) + geom_bar(aes(y=total, fill = "#E69F00"), stat="identity") + geom_line(aes(y=PercentPass*100)) + scale_y_continuous(name = "count", sec.axis = sec_axis(~./100))+labs(title = "Total Movies By Year & % Pass")
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

![](BechdelMovies_files/figure-markdown_github/Exploratory%20Plots-1.png)

``` r
movies %>% filter(year > 1972) %>% mutate(pass = ifelse(binary=="PASS",1,0),fail = ifelse(binary=="FAIL",1,0)) %>% group_by(year) %>% summarize(pass = sum(pass), fail = sum(fail)) %>% mutate(total = pass + fail, PercentPass = pass/total) %>% ggplot(aes(x=year)) + geom_bar(aes(y=pass, fill="pass"), stat="identity")+ geom_bar(aes(y=fail*-1, fill="fail"), stat="identity") + geom_point(aes(y=pass-fail))+ geom_line(aes(y=pass-fail)) + scale_fill_manual(values = c(pass="#D55E00", fail="#E69F00"), name="") +labs(title = "Total Movies By Year & % Pass Diverging")
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

![](BechdelMovies_files/figure-markdown_github/Exploratory%20Plots-2.png)

``` r
movies %>% filter(year > 1972) %>% mutate(pass = ifelse(binary=="PASS",1,0),fail = ifelse(binary=="FAIL",1,0)) %>% group_by(year) %>% summarize(pass = sum(pass), fail = sum(fail)) %>% mutate(total = pass + fail, PercentPass = pass/total) %>% ggplot(aes(x=total, y=PercentPass)) + geom_point() + geom_line(aes(y=.5))+labs(title = "Relationship between number of movies per year and % pass")
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

![](BechdelMovies_files/figure-markdown_github/Exploratory%20Plots-3.png)
