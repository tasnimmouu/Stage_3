# Single-Cell Marker Explorer (HackBio Stage 3)

## How to Run the App

1. Make sure the following files are in the same folder:
   - app.R  
   - expression_matrix.csv  
   - cell_metadata.csv  
   - umap_coordinates.csv  

2. Open the folder in RStudio.

3. Run the app using:

   shiny::runApp()

The Shiny application will launch in your browser.

---

## Gene Specificity Score

For each gene, a specificity score is calculated as:

    diff = mean_in - mean_out

Where:

- mean_in = average expression of the gene in the selected cell type  
- mean_out = average expression of the gene in all other cell types  

The specificity score (diff) measures how much higher a gene is expressed in the selected cell type compared to all other cell types. A larger positive value indicates stronger specificity.

---

## Marker Gene Selection

For a selected cell type:

1. Per-gene statistics are computed for all genes.
2. Genes are ranked by decreasing specificity score (diff).
3. If multiple genes have the same highest diff value, the gene with the higher detection rate within the selected cell type (det_in) is chosen.
4. The selected gene is used to color the UMAP plot.

This ensures deterministic and reproducible marker selection.
