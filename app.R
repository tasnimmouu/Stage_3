
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# ==============================
# Helper Functions (Required)
# ==============================

scale_0_100 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  if (rng[1] == rng[2]) return(rep(50, length(x)))
  (x - rng[1]) / (rng[2] - rng[1]) * 100
}

compute_gene_stats <- function(expr_mat, meta_df, target_ct) {
  
  in_cells  <- meta_df$cell_id[meta_df$cell_type == target_ct]
  out_cells <- meta_df$cell_id[meta_df$cell_type != target_ct]
  
  xin  <- expr_mat[in_cells, , drop = FALSE]
  xout <- expr_mat[out_cells, , drop = FALSE]
  
  det_in   <- colMeans(xin > 0)
  det_out  <- colMeans(xout > 0)
  
  mean_in  <- colMeans(xin)
  mean_out <- colMeans(xout)
  
  diff <- mean_in - mean_out
  
  data.frame(
    gene = colnames(expr_mat),
    det_in = det_in,
    det_out = det_out,
    mean_in = mean_in,
    mean_out = mean_out,
    diff = diff,
    stringsAsFactors = FALSE
  )
}

# ==============================
# Load Data
# ==============================

expression_df <- read.csv("expression_matrix.csv", check.names = FALSE)

# Convert to matrix with rownames = cell_id
expression_matrix <- expression_df
rownames(expression_matrix) <- expression_matrix$cell_id
expression_matrix <- expression_matrix[, -1]
expression_matrix <- as.matrix(expression_matrix)

cell_metadata <- read.csv("cell_metadata.csv")
umap_coordinates <- read.csv("umap_coordinates.csv")

cell_metadata$cell_id <- as.character(cell_metadata$cell_id)
umap_coordinates$cell_id <- as.character(umap_coordinates$cell_id)

# ==============================
# UI
# ==============================

ui <- fluidPage(
  titlePanel("Single-Cell Marker Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "selected_cell_type",
        "Select Cell Type:",
        choices = c("All", unique(cell_metadata$cell_type)),
        selected = "All"
      )
    ),
    
    mainPanel(
      plotOutput("umapPlot", height = "600px"),
      br(),
      verbatimTextOutput("markerInfo"),
      br(),
      DTOutput("markerTable")
    )
  )
)

# ==============================
# Server
# ==============================

server <- function(input, output) {
  
  merged_data <- reactive({
    cell_metadata %>%
      inner_join(umap_coordinates, by = "cell_id")
  })
  
  marker_stats <- reactive({
    
    req(input$selected_cell_type)
    
    if (input$selected_cell_type == "All") {
      return(NULL)
    }
    
    compute_gene_stats(
      expr_mat = expression_matrix,
      meta_df = cell_metadata,
      target_ct = input$selected_cell_type
    )
  })
  
  output$umapPlot <- renderPlot({
    
    data <- merged_data()
    
    if (input$selected_cell_type == "All") {
      
      ggplot(data, aes(x = UMAP_1, y = UMAP_2, color = cell_type)) +
        geom_point(size = 2) +
        theme_minimal() +
        labs(title = "UMAP Colored by Cell Type")
      
    } else {
      
      stats <- marker_stats()
      
      top_gene <- stats %>%
        arrange(desc(diff), desc(det_in)) %>%
        slice(1) %>%
        pull(gene)
      expr_umap <- merged_data()
      expr_umap[[top_gene]] <- expression_matrix[expr_umap$cell_id, top_gene]
      
      # SCALE EXPRESSION TO 0–100
      expr_umap[[top_gene]] <- scale_0_100(expr_umap[[top_gene]])
      
      ggplot(expr_umap, aes(x = UMAP_1, y = UMAP_2,
                            color = .data[[top_gene]])) +
        geom_point(size = 2) +
        scale_color_viridis_c(limits = c(0, 100)) +
        theme_minimal() +
        labs(title = paste("UMAP Colored by Marker:", top_gene),
             color = "Scaled Expression (0–100)")
      
    }
  })
  
  output$markerInfo <- renderText({
    
    if (input$selected_cell_type == "All") {
      return("Select a specific cell type to compute marker gene.")
    }
    
    stats <- marker_stats()
    
    top_row <- stats %>%
      arrange(desc(diff), desc(det_in)) %>%
      slice(1)
    
    paste0(
      "Selected Cell Type: ", input$selected_cell_type, "\n",
      "Top Marker Gene: ", top_row$gene, "\n",
      "Specificity Score (mean_in - mean_out): ",
      round(top_row$diff, 4)
    )
  })
  
  output$markerTable <- renderDT({
    
    if (input$selected_cell_type == "All") {
      return(NULL)
    }
    
    datatable(
      marker_stats(),
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
}

shinyApp(ui = ui, server = server)
