# creates for dates in class

### Library
library(tidyverse)
library(knitr)
library(kableExtra) ## for "Awesome HTML Table with knitr::kable"

### 13 Sitzungen (inkl. Vorlesungsfreitage/ -zeit)
Sitzung <- c(1:13)

### Daten für jede Sitzung
Termin <- c()

### für jede Sitzung
for (i in Sitzung){

    ### einen Tag hinzufügen, beginnend von der ersten Sitzung
    Tag <- (as.Date("2019-04-29") + (i*7-7)) %>% format("%d. %B %Y")

    ### den Tag dem Termin hinzufügen
    Termin <- c(Termin, Tag)
}


### Thema für jede Sitzung
Thema <- c(

    ### Sitzung 1
    # Inhalt
    'Orga, Kennenlernen, Wissenschaft, [Folien](./slides/01-orga.html), [Protokoll](./protocols/01-protocol.html)',

    ### Sitzung 2
    'Forschungsideen, Versuchsdesign & Hypothesen, [Folien](./slides/02-hypo.html), [Protokoll](./protocols/02-protocol.html)',

    ### Sitzung entfällt
    'Entfällt: Stiftungsfest',

    ### Sitzung 3
    'Präregistrierung, [Folien](./slides/03-prereg.html), [Protokoll](./protocols/03-protocol.html)',

    ### Sitzung 4
    'Design & Präregistrierung, [Folien](./slides/04-prep.html), [Protokoll](./protocols/04-protocol.html)',

    ### Sitzung 5
    'Power (und die dazugehörige [Simulation](./material/analysis.html)), [Folien](./slides/05-power.html), [Protokoll](./protocols/05-protocol.html)',

    ### Sitzung entfällt
    'Entfällt: Pfingsten',

    ### Sitzung 6
    'Power & Preregistrierung Abschluss, Erhebungsplan, [Protokoll](./protocols/06-protocol.html)',

    ### Sitzung 7
    'im Feld: Versuchsablauf',

    ### Sitzung 8
    'Datenexploration & -kommunikation, [Folien](./slides/08-analysis.html), [Protokoll](./protocols/08-protocol.html)',

    ### Sitzung entfällt
    'Entfällt: Konferenz',

    ### Sitzung 9
    'Poster, [Folien](./slides/09-abschluss.html), [Protokoll](./protocols/09-protocol.html)',

    ### Sitzung 13
    'Posterkongress (18.00h, R. 219, Röntgenring 10)')

### Nr. Termin Thema in einer Tabelle
Sitzungen <- data.frame(Sitzung, Termin, Thema) %>%

    ### Vorlesungsfreie Tage
    filter(

        ### Weihnachten
        Termin != "24. Dezember 2018",

        ### Silvester
        Termin != "31. Dezember 2018") %>%

    group_by(str_starts(Thema, "Entfällt")) %>%

    mutate(
        Sitzung = 1:n()) %>% ungroup() %>%

    mutate(

        ### Anzahl Sitzungen ohne vorlesungsfreie Tage
        Sitzung = case_when(
            str_starts(Thema, "Entfällt") ~ " ",
            !str_starts(Thema, "Entfällt") ~
                ifelse(
                    str_count(Sitzung) < 2,
                    str_c("0", Sitzung),
                    Sitzung))) %>%

    select('Nr.' = Sitzung, Termin, Thema)


### Tabelle in html für slides
sitzung_html <-
    Sitzungen %>%

    ### delete link to other slides in html table
    mutate(
        Thema = ifelse(

            # when pattern is found
            str_detect(string=Thema, pattern="Folien"),

            # extracts (deletes) everything following the pattern
            str_extract(string=Thema, pattern=".+?(?=, \\[Folien\\])"),
            as.character(Thema))) %>%

    kable(
        format = 'html',
        table.attr = "style='width:100%;'",
        align = c("c","c","l"),
        caption = "Übersicht - Sommersemester 2019"
        ) %>%
    kable_styling(font_size = 14)

### Tabelle in markdown für index.md
sitzung_md <- kable(Sitzungen, format = 'markdown', align = c("c","c","l"))

#rm(day, i, Nr., Thema, Termine)
