# Single-Cell Marker Explorer

## Live Shiny App

Access the deployed application here:

https://anika-hackbio3.shinyapps.io/hackbio_final/

---

## How to Run the App Locally

1. Download or clone this repository.
2. Ensure the following files are in the same folder:
   - app.R
   - expression_matrix.csv
   - cell_metadata.csv
   - umap_coordinates.csv
3. Open app.R in RStudio.
4. Click **Run App** or run the following command in the R console:

```r
shiny::runApp("path/to/Stage_3")
```

---

## Gene Specificity Score Definition

The gene specificity score is defined as:

diff = mean_in − mean_out

Where:

- mean_in = average expression of the gene in the selected cell type
- mean_out = average expression of the gene in all other cell types

A higher positive diff indicates stronger specificity of the gene for the selected cell type.

---

## Marker Gene Selection Rule (Deterministic)

Marker genes are selected using the following deterministic rule:

1. Compute diff = mean_in − mean_out for all genes.
2. Rank genes in descending order of diff.
3. If there is a tie, rank by higher detection rate within the selected cell type (det_in).
4. Select the top-ranked gene.

This ensures reproducibility — the same selected cell type will always return the same marker gene.

---

## Visualization Logic

- When **"All"** is selected, the UMAP is colored by cell type.
- When a specific cell type is selected, the UMAP is colored by the top marker gene expression.
- Gene expression values are scaled to 0–100 before visualization to ensure consistent and comparable color intensity across genes.

