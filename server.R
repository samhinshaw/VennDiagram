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
		radioButtons("columns_1", "Which columns do you wish to use for your comparisons?", items_1)
		
	})
	
	
	selectedCols_1 <- reactive({
		selectedCols_1 <- input$columns_1
		if (is.null(selectedCols_1)) {
			# User has not uploaded selected columns yet
			return(NULL)
		}
		selectedCols_1
	})
	# selectCriteria_1 <- interp(~ selectedCols_1(), OurFilename = quote(selectedCols_1()))
	
	output$theCols_1 <- renderTable({
		df <- filedata()
		cols_1 <- selectedCols_1()
		df %>%
			select_(.dots = cols_1) %>%
			head(5)
	})
	
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
		radioButtons("columns_2", "Which columns do you wish to use for your comparisons?", items_2)
		
	})
	
	selectedCols_2 <- reactive({
		selectedCols_2 <- input$columns_2
		if (is.null(selectedCols_2)) {
			# User has not uploaded selected columns yet
			return(NULL)
		}
		selectedCols_2
	})
	
	output$theCols_2 <- renderTable({
		df <- filedata()
		cols_2 <- selectedCols_2()
		df %>%
			select_(.dots = cols_2) %>%
			head(5)
	})
	
	output$OurVenn <- renderPlot({
		df_1 <- filedata()
		cols_1 <- selectedCols_1()
		df_2 <- filedata_2()
		cols_2 <- selectedCols_2()
		Vector1 <- filedata() %>% extract2(selectedCols_1())
		Vector2 <- filedata_2() %>% extract2(selectedCols_2())
		venn(list("One" = Vector1, "Two" = Vector2))
	})
	# VennD <- venn(list("Set 1" = GEx_nodes$Id, "Set 2" = Metab_nodes$Id))
	
	# Day01_VennD <- venn(list("GeneExpression" = Day01_GEx_nodes$Id, "Metabolomics" = Day01_Metab_nodes$Id), show.plot = FALSE)
	# Day01_gex_area <- length(attr(Day01_VennD, "intersections")$`GeneExpression`)
	# Day01_metab_area <- length(attr(Day01_VennD, "intersections")$`Metabolomics`)
	# Day01_cross_area <- length(attr(Day01_VennD, "intersections")$`GeneExpression:Metabolomics`)
}
