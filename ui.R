fluidPage(#theme = "bootstrap.css",
					useShinyjs(),
					tags$head(tags$title("Sam's Venn Diagrams")),
	h1("Sam's Venn Diagrams"),
	sidebarLayout(
		div(class = "sidebar", sidebarPanel(
			h3("Input"),
			hr(),
			textInput("userdata_1_NAME", "Name your first dataset:", value = "Area 1"),
			fileInput('userdata', 'Upload a CSV containing your data:',
								accept = c('text/csv', 
														 'text/comma-separated-values,text/plain', 
												 '.csv')),
			uiOutput("columnSelect_1"),
			# checkboxGroupInput('columns_1', 'Which columns do you wish to use for your comparisons?', choices = character(0), selected = character(0)),
			hr(),
			uiOutput("SecondCols"),
			conditionalPanel(condition = "input.SecondColumnInFirstDataset == 'Use a second dataset'",
				textInput("userdata_2_NAME", "Name your second dataset:", value = "Area 2"),
				fileInput('userdata_2', 'Upload a CSV containing your data:',
									accept = c('text/csv', 
														 'text/comma-separated-values,text/plain', 
														 '.csv'))
			),
			hr(),
			uiOutput("columnSelect_2"),
			# checkboxGroupInput('columns_2', 'Which columns do you wish to use for your comparisons?', choices = character(0), selected = character(0)),
			hr(),
			"Please note, at the moment we are only accept text spreadsheets with a header row.",
			"At the current time, uploading spreadsheets with many columns is untested"
)),
		div(class = "mainpanel", mainPanel(
			div(class ="maincontent",
					div(class = "CheckResults",
				"Check here to make sure you've selected the correct columns!",
				fluidRow(
					splitLayout(cellWidths = c("50%", "50%"), tableOutput("theCols_1"), tableOutput("theCols_2"))
				)
				# tableOutput("theCols_1"), tableOutput("theCols_2")
					),
				hr(),
				div(class = "VennDiagram",
						plotOutput("OurVenn", width = "600px", height = "600px")
				)
			
			
			
		)#,
		# hr(),
		# div(class = "footer", "CSS Theme 'Cosmo' by", a("Thomas Park", href="http://github.com/thomaspark", target="_blank"), "at", a("bootswatch.com", href="http://bootswatch.com", target="_blank"))
		))
	)
)
