## Live Shiny App

You can access the deployed application here:

https://anika-hackbio3.shinyapps.io/hackbio_final/

# Single-Cell Marker Explorer

## How to Run the App

1. Place app.R and all CSV files in the same folder.
2. Open the project in RStudio.
3. Run the app using:
   shiny::runApp()

---

## Gene Specificity Score

The specificity score is defined as:

diff = mean_in - mean_out

Where:
- mean_in = average gene expression in the selected cell type
- mean_out = average gene expression in all other cell types

A higher diff indicates stronger specificity.

---

## Marker Gene Selection

1. Compute statistics for all genes.
2. Rank genes by highest diff.
3. If there is a tie, choose the gene with higher det_in.

4. The top gene is used to color the UMAP.
