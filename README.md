# Single-Cell Marker Explorer

An interactive Shiny application for identifying and visualizing cell-type–specific marker genes from single-cell expression data.

---

## 🔗 Live Application

Access the deployed Shiny app here:

👉 https://anika-hackbio3.shinyapps.io/hackbio_final/

---

## ▶ How to Run the App Locally

1. Clone or download this repository.
2. Ensure the following files are located in the same directory:
   - `app.R`
   - `expression_matrix.csv`
   - `cell_metadata.csv`
   - `umap_coordinates.csv`
3. Open `app.R` in RStudio.
4. Click **Run App**, or run the following in the R Console:

```r
shiny::runApp()
```

The application will launch in your browser.

---

## 🧮 Gene Specificity Score

Marker genes are ranked using a gene specificity score defined as:

**diff = mean_in − mean_out**

Where:

- **mean_in** = mean expression of a gene within the selected cell type  
- **mean_out** = mean expression of the same gene across all other cell types  

A larger positive `diff` indicates stronger specificity of the gene for the selected cell type.

This scoring method ensures biologically interpretable marker identification.

---

## 🧬 Deterministic Marker Gene Selection

Marker selection follows a fully deterministic procedure:

1. Compute `diff = mean_in − mean_out` for all genes.
2. Rank genes in descending order of `diff`.
3. In case of ties, rank by higher detection rate within the selected cell type (`det_in`).
4. Select the top-ranked gene as the marker.

This guarantees:
- No randomness  
- Full reproducibility  
- Consistent marker selection for identical inputs  

---

## 📊 Visualization Logic

- When **"All"** is selected:
  - The UMAP is colored by cell type (categorical coloring).

- When a specific cell type is selected:
  - The UMAP is colored by the expression of the top-ranked marker gene.
  - Expression values are scaled to **0–100** before visualization.
  - A continuous color scale is used to represent relative expression intensity.

Scaling ensures consistent visualization across genes and improves interpretability.

---

## 🛠 Technologies Used

- R
- Shiny
- ggplot2
- dplyr
- DT

---

## 📌 Summary

This application enables:
- Interactive exploration of cell-type–specific markers
- Deterministic marker selection
- Scaled expression visualization
- Fully reproducible analysis

The app is fully runnable locally and publicly deployed for external access.
