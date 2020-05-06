library(meetupr)
library(dplyr)

# About: This script leverages the Meetup API to extract all events from a Meetup and other things

Sys.setenv(MEETUP_KEY = "################")  # This is private :P
MEETUP_KEY = "##################"  # This is private :P

urlname <- "CM-MDC"

past_events <- get_events(urlname, event_status = "past") %>% data.frame()
upcoming_events <- get_events(urlname, event_status = "upcoming") %>% data.frame()

all_events <- rbind(upcoming_events, past_events)

all_events <- subset(all_events, select = -c(resource))


test <- get_event_attendees(urlname, api_key = MEETUP_KEY, event_id = all_events$id[20])


write.csv(all_events, file = "CM-MDC_All_Events.csv",row.names=FALSE, na="")
