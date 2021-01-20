library(shiny)
library(sf)
library(plotly)

source('data.R')

function(input, output, session) {
    values <- reactiveValues(
        region = 'All Countries',
        category = 'Cases'
    )   
    
    load_data <- reactive({
        print('Loading data')
        
        read.csv('latest_cleansed_data.csv', check.names = FALSE) %>%
            rename(
                'Cumulative confirmed cases' = 'Confirmed',
                'Cumulative recovered cases' = 'Recovered',
                'Cumulative death cases' = 'Deaths'
            ) %>%
            select(
                Country = Country_Name,
                Region,
                
                GetColumns('Cases'),
                GetColumns('Population'),
                GetColumns('Health'),
                GetColumns('Education'),
                GetColumns('Economy'),
                GetColumns('Happiness')
            ) %>%
            arrange(
                Country
            )
    })   
    
    load_selected_data <- reactive({
        print('Loading selected data')
        
        load_data() %>%
            { if (values$region == 'All Countries' | values$region == '') filter(., TRUE) else filter(., Region == values$region) }
    })
    
    load_map_data <- reactive({
        print('Loading map data')
        world_shapefiles <- read_sf(dsn = 'world-shape-files/ne_50m_admin_0_countries.shp')
        
        world_shapefiles[world_shapefiles$NAME == 'Antigua and Barb.', 'NAME'] <- 'Antigua and Barbuda'
        world_shapefiles[world_shapefiles$NAME == 'Central African Rep.', 'NAME'] <- 'Central African Republic'
        world_shapefiles[world_shapefiles$NAME == 'Dominican Rep.', 'NAME'] <- 'Dominican Republic'
        world_shapefiles[world_shapefiles$NAME == 'Eq. Guinea', 'NAME'] <- 'Equatorial Guinea'
        world_shapefiles[world_shapefiles$NAME == 'eSwatini', 'NAME'] <- 'Eswatini'
        world_shapefiles[world_shapefiles$NAME == 'Marshall Is.', 'NAME'] <- 'Marshall Islands'
        world_shapefiles[world_shapefiles$NAME == 'St. Kitts and Nevis', 'NAME'] <- 'Saint Kitts and Nevis'
        world_shapefiles[world_shapefiles$NAME == 'St. Vin. and Gren.', 'NAME'] <- 'Saint Vincent and the Grenadines'
        world_shapefiles[world_shapefiles$NAME == 'São Tomé and Principe', 'NAME'] <- 'Sao Tome and Principe'
        world_shapefiles[world_shapefiles$NAME == 'Solomon Is.', 'NAME'] <- 'Solomon Islands'
        world_shapefiles[world_shapefiles$NAME == 'S. Sudan', 'NAME'] <- 'South Sudan'
        world_shapefiles[world_shapefiles$NAME == 'United States of America', 'NAME'] <- 'United States'
        
        world_shapefiles %>%
            right_join(load_selected_data(), by = c('NAME' = 'Country'))
    })
    
    output$regions <- renderUI({
        items <- sort(unique(load_data()[['Region']]))
        
        selectInput(
            inputId = 'region',
            label = NULL,
            choices = c('Select Region' = '', 'All Countries' = 'All Countries', items),
            selected = 'All Countries'
        )
    })
    
    output$variables <- renderUI({
        selectInput(
            inputId = 'variable',
            label = NULL,
            choices = c('Select Variable' = '', setNames(GetColumnNames(values$category), GetColumnDescriptions(values$category)))
        )
    })
    
    observeEvent(
        input$region,
        ignoreNULL = TRUE,
        
        {
            if (input$region == '') {
                return
            }
            
            values$region <- input$region
        }    
    )
    
    observeEvent(
        input$variable,
        ignoreNULL = TRUE,
        
        {
            if (input$variable == '') {
                return
            }
            
            print(paste0('Variable - ', input$variable))
        }
    )    
    
    observeEvent(
        input$tab,
        {
            if (input$tab %in% GetCategories()) {
                values$category <- input$tab
                updateSelectInput(session, 'variable', selected = GetColumnNames(input$tab)[1])
            }
        }
    )
    
    PlotMap <- reactive({
        if (is.null(input$region)) {
            return (NULL)
        }
        
        if (input$tab != GetCategory(input$variable)) {
            return (NULL)
        }
        
        print(paste0('Loading map / Tab = ', input$tab))
        print(paste0('Loading map / Var = ', input$variable))
        
        map_data <- load_map_data()
        variable <- input$variable
        
        colors <- switch(
            GetMood(variable),
            'Good' = c('#addd8e', 'green4'),
            'Neutral' = c('#fec44f', '#d95f0e'),
            'Bad' = c('#ffeda0', 'red4')
        )
        
        qpal <- colorNumeric(colors, map_data[[variable]], na.color = '#bdbdbd')
        
        region <- input$region
        
        if (region == 'All Countries') {
            lng = 0
            lat = 0
            zoom = 1
        }
        else if (region == 'Africa') {
            lng = 20
            lat = 0
            zoom = 3
        }
        else if (region == 'Americas') {
            lng = -85
            lat = 12
            zoom = 2
        }
        else if (region == 'Asia') {
            lng = 85
            lat = 25
            zoom = 3
        }
        else if (region == 'Europe') {
            lng = 20
            lat = 57
            zoom = 3
        }
        else if (region == 'Oceania') {
            lng = 145
            lat = -21
            zoom = 3
        }
        
        map_data %>%
            leaflet() %>%
            addTiles() %>%
            setView(lng = lng, lat = lat, zoom = zoom) %>%
            addPolygons(
                stroke = TRUE,
                color = 'black',
                weight = 1,
                opacity = 1,
                smoothFactor = 1,
                fillOpacity = 0.5,
                fillColor = qpal(map_data[[variable]]),
                label = ~paste0(NAME, ' - ', map_data[[variable]])
            ) %>%
            addLegend(
                pal = qpal, 
                values = map_data[[variable]], 
                opacity = 0.8,
                title = variable,
                position = 'bottomleft',
                na.label = 'NA'
            )
    })    
    
    output$data <- renderDT(
        { load_selected_data() },
        
        rownames = FALSE,
        class = 'cell-border compact stripe',
        extensions = c('Responsive')
    )
    
    output$notes <- renderTable(
        {
            columns %>%
                select(-Mood)
        },
        
        bordered = TRUE,
        striped = TRUE,
        hover = TRUE
    )
    
    PlotCorrelation <- reactive({
        if (is.null(input$variable)) {
            return (NULL)
        }
        
        if (input$tab != GetCategory(input$variable)) {
            return (NULL)
        }
        
        print(paste0('Loading plot / Tab = ', input$tab))
        print(paste0('Loading plot / Var = ', input$variable))
        
        data = load_selected_data()
        
        Region <- input$region
        Description <- GetDescription(input$variable)

        CorrTest <- cor.test(data[[input$variable]], log10(data$Confirmed))
        Plabel <- ifelse(CorrTest$p.value < 0.001, 'p < 0.001', paste0('p = ', round(CorrTest$p.value, 3)))
        x_max <- max(data[[input$variable]], na.rm = TRUE)
        x_min <- min(data[[input$variable]], na.rm = TRUE)
        y_max <- max(log10(data$Confirmed), na.rm = TRUE)
        y_min <- min(log10(data$Confirmed), na.rm = TRUE)
        x_label <- (x_max - x_min) / 5 + x_min
        y_label <- y_max - (y_max - y_min) / 10

        viz <- ggplot(data = data, aes(x = .data[[input$variable]], y = log10(Confirmed))) +
            geom_point(aes(text = paste0('Country: ', Country), color = Region)) +
            geom_smooth(method = 'lm', formula = y ~ x) +
            annotate(
                'text', 
                label = paste0('R = ', round(CorrTest$estimate, 2), ', ', Plabel), 
                x = x_label,
                y = y_label,
                color = 'steelblue',
                size = 5
            ) +
            labs(
                # title = paste0(Region, ' - ', Description, ' and Confirmed Cases'),
                x = Description,
                y = 'Log(Confirmed Cases)'
            ) +
            ggplot_defaults
        
        ggplotly(viz) %>%
            layout(
                title = paste0(Region, ' - ', Description, ' and Confirmed Cases'),
                margin = 50
            )
    })    
    
    output$map_cases <- renderLeaflet({
        PlotMap()
    })
    
    output$map_population <- renderLeaflet({
        PlotMap()
    })
    
    output$map_health <- renderLeaflet({
        PlotMap()
    })
    
    output$map_education <- renderLeaflet({
        PlotMap()
    })
    
    output$map_economy <- renderLeaflet({
        PlotMap()
    })
    
    output$map_happiness <- renderLeaflet({
        PlotMap()
    })
    
    output$correlation_population <- renderPlotly({
        PlotCorrelation()
    })
    
    output$correlation_health <- renderPlotly({
        PlotCorrelation()
    })
    
    output$correlation_education <- renderPlotly({
        PlotCorrelation()
    })
    
    output$correlation_economy <- renderPlotly({
        PlotCorrelation()
    })
    
    output$correlation_happiness <- renderPlotly({
        PlotCorrelation()
    })
    
}

