columns <- data.frame(
    Category = c(
        rep('Cases', 3),
        rep('Population', 5),
        rep('Education', 4),
        rep('Health', 18),
        rep('Economy', 5),
        rep('Happiness', 5)
    ),
    Name = c(
        'Confirmed', 'Recovered', 'Deaths',
        'Population', 'TestPeople', 'TestSamples', 'TestPerformed', 'TestUnclear',        
        'Tertiary', 'Enrollment', 'Literacy', 'EducationExp',
        'ComDiseases', 'NonComDiseases', 'Injury', 'DeathRate', 'Diabetes', 'ImmDPT', 'ImmHep', 'ImmMeasles', 'LifeExpectancy', 'Anemia', 'Undernourishment', 'Surgical', 'Nurse', 'Physician', 'Bed', 'HealthExp', 'HealthCareIndex', 'HealthCareRank',        
        'Labor', 'NetODA', 'Inflation', 'GDP', 'Unemployment',
        'Happiness', 'Social', 'Freedom', 'Generosity', 'Corruption'
    ),
    Description = c(
        'Cumulative confirmed cases',
        'Cumulative recovered cases',
        'Cumulative death cases',
        
        'Population ages 15-64 (% of total population)',
        'Covid19_test_conducted_people tested',
        'Covid19_test_conducted_samples tested',
        'Covid19_test_conducted_tests performed',
        'Covid19_test_conducted_units unclear',
        
        'School enrollment, tertiary (% gross)',
        'School enrollment, secondary (% net)',
        'Literacy rate, adult total (% of people ages 15 and above)',
        'Government expenditure on education, total (% of GDP)',
        
        'Cause of death, by communicable diseases and maternal, prenatal and nutrition conditions (% of total)',
        'Cause of death, by non-communicable diseases (% of total)',
        'Cause of death, by injury (% of total)',
        'Death rate, crude (per 1,000 people)',
        'Diabetes prevalence (% of population ages 20 to 79)',
        'Immunization, DPT (% of children ages 12-23 months)',
        'Immunization, HepB3 (% of one-year-old children)',
        'Immunization, measles (% of children ages 12-23 months)',
        'Life expectancy at birth, total (years)',
        'Prevalence of anemia among children (% of children under 5)',
        'Prevalence of undernourishment (% of population)',
        'Risk of impoverishing expenditure for surgical care (% of people at risk)',
        'Nurse and Midwives(per1,000People)',
        'Physician(per1,000People)',
        'HOSPITAL_BED_TOTAL(1000HAB)',
        'Health Expenditure (% of GDP)',
        'Health Care Index _2000',
        'HealthCare_Rank_2000',
        
        'Labor force, total',
        'Net ODA Received (2018)',
        'Inflation (2019)',
        'GDP (2019)',
        'Unemployment (2019)',
        
        'Happiness Score (2019)',
        'Social support (2019)',
        'Freedom to make life choices (2019)',
        'Generosity (2019)',
        'Perceptions of corruption (2019)'
    ),
    Mood = c(
        'Neutral', 'Good', 'Bad',
        'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Neutral',        
        'Good', 'Good', 'Good', 'Good',
        'Bad', 'Bad', 'Bad', 'Bad', 'Bad', 'Good', 'Good', 'Good', 'Good', 'Bad', 'Bad', 'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Good', 'Good', 'Good',
        'Neutral', 'Neutral', 'Neutral', 'Good', 'Bad',
        'Good', 'Good', 'Good', 'Good', 'Bad'
    )
)


GetCategories <- function() {
    columns %>%
        pull(Category) %>%
        unique() %>%
        sort()
}

GetColumnNames <- function(category = 'All') {
    columns %>%
        { if (category == 'All') filter(., TRUE) else filter(., Category == category) } %>%
        pull(Name)
    }

GetColumnDescriptions <- function(category = 'All') {
    columns %>%
        { if (category == 'All') filter(., TRUE) else filter(., Category == category) } %>%
        pull(Description)
}

GetColumns <- function(category = 'All') {
    columns <- GetColumnDescriptions(category)
    names(columns) <- GetColumnNames(category)
    columns
}

GetCategory <- function(name) {
    columns %>%
        filter(Name == name) %>%
        pull(Category)
}

GetDescription <- function(name) {
    columns %>%
        filter(Name == name) %>%
        pull(Description)
}

GetMood <- function(name) {
    columns %>%
        filter(Name == name) %>%
        pull(Mood)
}

ggplot_defaults <- theme(
    plot.title = element_text(face = 'bold', size = rel(1), hjust = 0),
    axis.title = element_text(face = 'bold'),
    plot.background = element_blank(),
    panel.background = element_blank(),
    panel.grid.major.y = element_line(color = 'grey')
)
