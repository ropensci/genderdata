library(dplyr)
library(tidyr)
library(stringr)
library(devtools)

napp_raw <- readRDS("data-raw/napp-name-counts.rds")


# Test that we can extract a name from its initials
test_initials <- c("marie b", "suda. g.", "sudah m.", "sudan j.", "sudie e. k.",
                   "sudie h. l.", "sudie m b", "sudie taylor", "sue a.j.",
                   "sue b.s.", "h. l. sue", "h l. sue", "h. l sue")
str_extract(test_initials, "\\w{3,}")

napp_countries <- data_frame(
  nappster = c(1, 2, 3, 4, 6, 7),
  country = c("Canada", "United Kingdom", "Iceland",
              "Norway", "Sweden", "Denmark")
)

napp <- napp_raw %>%
  mutate(name = str_extract(name_lowered, "\\w{3,}")) %>%
  select(-name_lowered) %>%
  filter(sex != 9,
         sex != 8,
         name != "mrs",
         nappster <= 7, nappster != 5, # keep only the countries we want
         !str_detect(name_lowered, "_"),
         !str_detect(name_lowered, "\\d"),
         birthyear <= 1911,
         !is.na(birthyear)
         ) %>%
  group_by(name, nappster, birthyear, sex) %>%
  tally(n) %>%
  spread(sex, n, fill = 0) %>%
  rename(male = `1`, female = `2`) %>%
  left_join(napp_countries, by = "nappster") %>%
  select(name, country, year = birthyear, female, male)

use_data(napp, compress = "xz", overwrite = TRUE)
