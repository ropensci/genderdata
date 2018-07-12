#' @title Finnish name-gender mappings
#' @description Finnish name-gender mappings from the Finnish
#' population register (VRK; version 3/2016).
#' @param ... Arguments to be passed
#' @return A data_frame with the field "name" (first name), followed
#' by the population frequencies and population counts for that name.
#' @author Leo Lahti \email{leo.lahti@iki.fi}
#' @examples tab <- get_gender_fi()
#' @export
#' @details Information from the Finnish Population register. All
#' first names for living Finnish citizens that live in Finland and
#' abroad in 2016. Only names with frequency n>10 are included.
#'  Source: avoindata.fi service and Vaestorekisterikeskus (VRK).
#'  For a complete data description, see:
#'  \url{https://www.avoindata.fi/data/fi/dataset/none}
#'  Version: 3/2016
#'  Data license CC-BY 4.0
#' @keywords data

    # Male names
    f <- "https://www.avoindata.fi/dataset/57282ad6-3ab1-48fb-983a-8aba5ff8d29a/resource/53667ad0-538c-4686-86e0-361c129dcd95/download/HNimidatan-avaaminen2016JulkaistavatMiehetkaikkietunimet2016.csv"
    male <- read.csv(f, sep = ";", fileEncoding = "latin1", stringsAsFactors = FALSE)
    names(male) <- c("name", "n")
    male$gender <- "male"

    # Female names
    f <- "https://www.avoindata.fi/dataset/57282ad6-3ab1-48fb-983a-8aba5ff8d29a/resource/cc4dc77d-a80f-423f-b4ef-07394943d7c3/download/HNimidatan-avaaminen2016JulkaistavatNaisetkaikkietunimet2016.csv"
    female <- read.csv(f, sep = ";", fileEncoding = "latin1", stringsAsFactors = FALSE)
    names(female) <- c("name", "n")
    female$gender <- "female"

    # Combine male and female tables
    tab <- as.data.frame(rbind(male, female))

    tab$name <- factor(tab$name)
    tab$gender <- factor(tab$gender, levels = c("female", "male"))
    rownames(tab) <- NULL    

    # Ensure that numerics are numerics
    tab$n <- as.numeric(as.character(gsub(" ", "", tab$n)))

    # Remove single letter names
    library(stringr)
    tab$name <- gsub("  ", " ", str_trim(gsub("\\.", " ", tab$name)))
    tab <- tab[nchar(tab$name) > 1, ]

    # Save the data
    gender_fi <- tab    
    save(gender_fi, file = "gender_fi.rda", compress = "xz")





