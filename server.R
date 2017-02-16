function(input, output, session) {
	
	filedata <- reactive({
		infile <- input$userdata
		if (is.null(infile)) {
			# User has not uploaded a file yet
			return(NULL)
		}
		read_csv(infile$datapath)
	})

	
	output$columnSelect_1 <- renderUI({
		df_2 <- filedata()
		if (is.null(df)) return(NULL)
		
		items_1 <- names(df_2)
		names(items_1) <- items_1
		checkboxGroupInput("columns_1", "Which columns do you wish to use for your comparisons?", items_1)
		
	})
	
	
	
	
	
	
	
	# observe({
	# 	updateCheckboxGroupInput(session, "columns_1",
	# 										choices = outVar()
	# 	)})
	filedata_2 <- reactive({
		infile_2 <- input$userdata_2
		if (is.null(infile_2)) {
			# User has not uploaded a file yet
			return(NULL)
		}
		read_csv(infile_2$datapath)
	})
	
	output$columnSelect_2 <- renderUI({
		df_2 <- filedata_2()
		if (is.null(df_2)) return(NULL)
		
		items_2 <- names(df_2)
		names(items_2) <- items_2
		checkboxGroupInput("columns_2", "Which columns do you wish to use for your comparisons?", items_2)
		
	})
	
	output$theColNames <- renderPrint({
		input$userdata %>%
			select(input$columns_2) %>%
			head(5)
	})

	

	# Day01_VennD <- venn(list("GeneExpression" = Day01_GEx_nodes$Id, "Metabolomics" = Day01_Metab_nodes$Id), show.plot = FALSE)
	# Day01_gex_area <- length(attr(Day01_VennD, "intersections")$`GeneExpression`)
	# Day01_metab_area <- length(attr(Day01_VennD, "intersections")$`Metabolomics`)
	# Day01_cross_area <- length(attr(Day01_VennD, "intersections")$`GeneExpression:Metabolomics`)
}
