library(dplyr)
nasa1<-as_data_frame(nasa)
nasa1
View(nasa1)

nasa2 <-nasa1 %>% filter(((lat=>29.56) & (lat<=33.09)) & ((long => -110.93) &(long <= -90.55)))
nasa2

View(nasa2)

nasa1 <- nasa1 %>%
  mutate(tmpprop =temperature/surftemp )

nasa1

nasa3=nasa1 %>% group_by(year) %>% summarise(pres_mean=mean(pressure,na.rm = TRUE),pres_sd=sd(pressure,na.rm = TRUE),
                    ozone_mean=mean(ozone,na.rm = TRUE),ozone_sd=sd(ozone,na.rm = TRUE),
                    tmpprop_mean=mean(tmpprop,na.rm = TRUE),tmpprop_sd=sd(tmpprop,na.rm = TRUE)) 
nasa3

nasa3 %>%
  arrange(desc(ozone_mean))

