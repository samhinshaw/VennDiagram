## Let's start off with some placeholder text pulled from wikipedia. Our initial
## example will be comparing the words in these two paragraphs.

## Pasted in text of first two paragraphs from wikipedia example. 
VennDiagramText <- "A Venn diagram (also called a set diagram or logic diagram) is a diagram that shows all possible logical relations between a finite collection of different sets. These diagrams depict elements as points in the plane, and sets as regions inside closed curves. A Venn diagram consists of multiple overlapping closed curves, usually circles, each representing a set. The points inside a curve labelled S represent elements of the set S, while points outside the boundary represent elements not in the set S. Thus, for example, the set of all elements that are members of both sets S and T, S∩T, is represented visually by the area of overlap of the regions S and T. In Venn diagrams the curves are overlapped in every possible way, showing all possible relations between the sets. They are thus a special case of Euler diagrams, which do not necessarily show all relations. Venn diagrams were conceived around 1880 by John Venn. They are used to teach elementary set theory, as well as illustrate simple set relationships in probability, logic, statistics, linguistics and computer science. A Venn diagram in which in addition the area of each shape is proportional to the number of elements it contains is called an area-proportional or scaled Venn diagram."
EulerDiagramText <- "An Euler diagram is a diagrammatic means of representing sets and their relationships. Typically they involve overlapping shapes, and may be scaled, such that the area of the shape is proportional to the number of elements it contains. They are particularly useful for explaining complex hierarchies and overlapping definitions. They are often confused with the Venn diagrams. Unlike Venn diagrams which show all possible relations between different sets, the Euler diagram shows only relevant relationships. The first use of 'Eulerian circles'' is commonly attributed to Swiss mathematician Leonhard Euler (1707–1783). In the United States, both Venn and Euler diagrams were incorporated as part of instruction in set theory as part of the new math movement of the 1960s. Since then, they have also been adopted by other curriculum fields such as reading[1] as well as organizations and businesses."

## Quick function to clean up string with stringr
Clean_String <- function(string){
	# Lowercase
	temp <- tolower(string)
	temp <- stringr::str_replace_all(temp,"\'s", "") # remove possessives
	#' Remove everything that is not a number or letter (may want to keep more 
	#' stuff in your actual analyses). 
	temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ")
	# Shrink down to just one white space
	temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
	# Split it
	temp <- stringr::str_split(temp, " ")[[1]]
	# Get rid of trailing "" if necessary
	indexes <- which(temp == "")
	if(length(indexes) > 0){
		temp <- temp[-indexes]
	} 
	return(temp)
}

# Use the function to clean the strings
EulerDiagramText %<>% Clean_String()
VennDiagramText %<>% Clean_String()

## Start the shiny server!
function(input, output, session) {
	
	# First read in the user-uploaded dataset
	filedata <- reactive({ # 																# this must be done in a reactive context.
		infile <- input$userdata # 														# this is the input, quickly send it to a new variable
		if (is.null(infile)) { # 															# if a file has not been uploaded yet, return NULL to avoid ugly user-facing errors
			return(NULL)
		}
		read_csv(infile$datapath) # 													# If a file has been read in, read it with readr::read_csv()!
	})

	## Create a UI element for selecting columns from the uploaded CSV
	output$columnSelect_1 <- renderUI({ # 									# The renderUI context is reactive-
		df_1 <- filedata() # 																	# take in the file and check quickly send it to a new variable
		if (is.null(df_1)) { # 																# if a file has not been uploaded yet, return NULL to avoid ugly user-facing errors
			return(NULL) 
		} else {
			items_1 <- names(df_1) # 														# Quickly get the column names
			names(items_1) <- items_1 # 												# And name them again for the radio buttons!
			radioButtons("columns_1", "Choose your first set", items_1)
		}
	})
	
	
	selectedCols_1 <- reactive({ # 													# Read in the column that was selected 
		selectedCols_1 <- input$columns_1
		if (is.null(selectedCols_1)) {
			# User has not selected columns yet
			return(NULL)
		} else{
			selectedCols_1
		}
	})

	output$theCols_1 <- renderTable({
		if (is.null(selectedCols_1())){
			return(NULL)
		} else {
			df <- filedata()
			cols_1 <- selectedCols_1()
			df %>%
				select_(.dots = cols_1) %>%
				head(5)
		}

	})
	
	output$SecondCols <- renderUI({
		df_1 <- filedata()
		if (is.null(df_1)) {
			return(NULL)
		} else{
			items_1 <- names(df_1)
			names(items_1) <- items_1
			radioButtons("SecondColumnInFirstDataset", "Choose your second set", c(items_1, "Use a second dataset"))
		}
	})
	
	
	filedata_2 <- reactive({
		infile_2 <- input$userdata_2
		if (is.null(infile_2)) {
			# User has not uploaded a file yet
			return(NULL)
		} else{
			read_csv(infile_2$datapath)
		}
	})
	
	output$columnSelect_2 <- renderUI({
		df_2 <- filedata_2()
		if (is.null(df_2)) {
			return(NULL)
		} else{
			items_2 <- names(df_2)
			names(items_2) <- items_2
			radioButtons("columns_2", "Which columns do you wish to use for your comparisons?", items_2)
		}
	})
	
	selectedCols_2 <- reactive({
		if (input$SecondColumnInFirstDataset == "Use a second dataset"){
			selectedCols_2 <- input$columns_2
		} else {
			selectedCols_2 <- input$SecondColumnInFirstDataset
		}
		if (is.null(selectedCols_2)) {
			# User has not uploaded selected columns yet
			return(NULL)
		} else {
			return(selectedCols_2)
		}
	})
	
	output$theCols_2 <- renderTable({
		if (is.null(selectedCols_2())){
			return(NULL)
		} else {
			df <- filedata_2()
			cols_2 <- selectedCols_2()
			df %>%
				select_(.dots = cols_2) %>%
				head(5)
		}
	})

	name_1 <- reactive({
		if (is.null(input$userdata_1_NAME)) {
			# User has not uploaded selected columns yet
			return(NULL)
		} else {
			input$userdata_1_NAME
		}
	})

	name_2 <- reactive({
		if (is.null(input$userdata_2_NAME)) {
			# User has not uploaded selected columns yet
			return(NULL)
		} else {
			input$userdata_2_NAME
		}
	})
	
	output$OurVenn <- renderPlot({
		if (is.null(selectedCols_1()) | is.null(selectedCols_2())){
			venn(list("Venn Diagram Wiki" = VennDiagramText, "Euler Diagram Wiki" = EulerDiagramText))
		} else {
			Vector1 <- filedata() %>% extract2(selectedCols_1())
			Vector2 <- filedata_2() %>% extract2(selectedCols_2())
			
			VennList <- list(Vector1, Vector2)
			names(VennList) <- c(name_1(), name_2())
			venn(VennList)
		}
	})
}
