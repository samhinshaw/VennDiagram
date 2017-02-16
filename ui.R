# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
fluidPage(theme = "bootstrap.css",
					useShinyjs(),
					tags$head(tags$title("Sam's Venn Diagrams")),
	h1("Sam's Venn Diagrams"),
	sidebarLayout(
		div(class = "sidebar", sidebarPanel(
			h3("Input"),
			hr(),
			fileInput('userdata', 'Please upload the data you wish to make a venn diagram of!',
								accept = c('text/csv', 
												 'text/comma-separated-values,text/plain', 
												 '.csv')),
			uiOutput("columnSelect_1"),
			# checkboxGroupInput('columns_1', 'Which columns do you wish to use for your comparisons?', choices = character(0), selected = character(0)),
			hr(),
			fileInput('userdata_2', 'If you have a second spreadsheet, please upload it here.',
								accept = c('text/csv', 
													 'text/comma-separated-values,text/plain', 
													 '.csv')),
			"If you have a second dataset you wish to use, please upload it here",
			hr(),
			uiOutput("columnSelect_2"),
			# checkboxGroupInput('columns_2', 'Which columns do you wish to use for your comparisons?', choices = character(0), selected = character(0)),
			hr(),
			"Please note, at the moment we are only accept text spreadsheets with a header row.",
			"At the current time, uploading spreadsheets with many columns is untested"
)),
		div(class = "mainpanel", mainPanel(
			textOutput("theColNames"), 
			
			
			
			
			hr(),
			div(class = "footer", "CSS Theme 'Cosmo' by", a("Thomas Park", href="http://github.com/thomaspark", target="_blank"), "at", a("bootswatch.com", href="http://bootswatch.com", target="_blank"))
		))
	)
)