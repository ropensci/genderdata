# The downloaded data from the North American Population Project was too big to
# fit into memory on my machine, so I loaded it into a Postgres database. The
# structure of the data matches that in the file `napp-sample-data.csv`. The
# original data contains one row for each person in the NAPP database. See the
# file `napp_0001.cbk.txt` for details.
#
# This script aggregates the unique combinations of persons born with a name in
# NAPP country per year, weighting them by the `PERWT` variable in NAPP. It then
# saves the data for cleaning in memory.
library(dplyr)

gender_db <- src_postgres("gender")
napp      <- tbl(gender_db, "napp_births")

name_counts <- napp %>%
  mutate(name_lowered = tolower(name_first)) %>%
  group_by(nappster, birthyear, name_lowered, sex) %>%
  tally(perwt)

name_counts_collected <- collect(name_counts)

saveRDS(name_counts_collected, "data-raw/napp-name-counts.rds")
