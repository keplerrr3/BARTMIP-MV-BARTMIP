# MV-BARTMIP: Multi-View Multi-Instance Learning for Health Recovery Monitoring in Older Adults

This repository contains the implementation code for the paper:

> **Multi-View Multi-Instance Learning for Health Recovery Monitoring in Older Adults**  
> Veselka Boeva, Alexander J. O. Ojutkangas, Shahrooz Abghari  
> *Blekinge Institute of Technology, Sweden*  
> Presented at HCAIxIA 2025

---


## Abstract
In this study, we propose a multi-view version of the BARTMIP algorithm, which can learn from data for which only coarse-grained labels are provided. The proposed MV-BARTMIP algorithm can deal with weakly annotated multi-modal data and is able to handle cases of missing data, including modalities and views. The performance of the MV-BARTMIP algorithm is evaluated in a scenario involving the monitoring of older adults' health recovery at home following hip replacement surgery. The performance of MV-BARTMIP and the traditional BARTMIP is benchmarked against several baseline solutions. The experimental results demonstrate that approaching the use case as a multi-view, multi-instance learning task results in more robust and interpretable models. MV-BARTMIP shows superior performance to the best baseline model in all but one scenario, where the results are comparable. Furthermore, its performance is comparable to that of the BARTMIP algorithm, which outperforms the best baseline model in all experimental scenarios.

## Dataset
These algorithms were ran on the **MAISON-LLF** dataset:

- **Modalities**: Smartphone, smartwatch, motion detectors, sleep-tracking.
- **Labels**: Bi-weekly **Social Isolation Scale (SIS)** and **Oxford Hip Score (OHS)**.
---

##  Algorithms

### Ex1: BARTMIP

### Ex2: MV-BARTMIP
- Extends BARTMIP to a multi-view-and Consensus-Clustering approach.

## Evaluation
- Evaluated with three feature sets:
  - All features
  - Top 16 SHAP features
  - Top 16 features + demographics
- Metrics: MAE and R²
- Uses 5-fold CV and LOSO CV
### Acknowledgement of SHAP Implementation
The code for selecting the most relevant features using SHAP values was taken from the [MAISON-LLF repository](https://github.com/abedidev/maison-llf).


## Requirements
A **Dockerfile** is provided to ensure reproducible environment setup. 

---
# Time Complexity Analysis

We analyze the time complexity of **Bartmip** and **Mv-Bartmip**, assuming hyperparameters (number of clusters $k_i$, $K$) are predefined.

### Notation
- $N$ : Number of bags  
- $M$ : Maximum instances per bag  
- $m$ : Number of views  
- $k$ : Clusters in Bartmip (single view)  
- $k_{\text{max}} = \max_i k_i$ : Maximum clusters per view in Mv-Bartmip  
- $K$ : Consensus clusters in Mv-Bartmip  
- $T$ : Iterations for k-medoids (fixed)  
- $d$ : Feature dimension in consensus clustering  

---

### 1. Bartmip Complexity
The algorithm involves:  

1. **BAMIC clustering**  
   - Pairwise average Hausdorff distance computation: $O(N^2 \cdot M^2)$  
   - k-medoids clustering: $O(T \cdot k \cdot N^2)$  

2. **Bag transformation**  
   - Distance to $k$ medoids: $O(N \cdot k \cdot M^2)$  

3. **Supervised training**  
   - $O(C_{\text{train}}(N, k))$  

**Overall complexity:**  
$O_{\text{Bartmip}} = O(N^2 \cdot (M^2 + T \cdot k)) + O(N \cdot k \cdot M^2) + O(C_{\text{train}}(N, k))$

---

### 2. Mv-Bartmip Complexity
The multi-view extension adds:  

1. **Per-view clustering**  
   - Run BAMIC for $m$ views: $O(m \cdot N^2 \cdot (M^2 + T \cdot k_{\text{max}}))$  

2. **Consensus clustering**  
   - Cluster $\sum k_i \leq m \cdot k_{\text{max}}$ points into $K$ groups:  
     $O((m \cdot k_{\text{max}})^2 \cdot (d + T \cdot K))$  

3. **Bag transformation**  
   - Distance to $K$ consensus clusters across $m$ views: $O(N \cdot K \cdot m \cdot M^2)$  

4. **Supervised training**  
   - $O(C_{\text{train}}(N, K))$  

**Overall complexity:**  
$O_{\text{Mv-Bartmip}} = O(m \cdot N^2 \cdot (M^2 + T \cdot k_{\text{max}})) + O((m \cdot k_{\text{max}})^2 \cdot (d + T \cdot K)) + O(N \cdot K \cdot m \cdot M^2) + O(C_{\text{train}}(N, K))$

---

### 3. Comparison
For large $N$, the $O(N^2)$ terms dominate.  
Mv-Bartmip is approximately $m$ times more expensive than Bartmip:

$\frac{O_{\text{Mv-Bartmip}}}{O_{\text{Bartmip}}} \approx \frac{m \cdot (M^2 + T \cdot k_{\text{max}})}{M^2 + T \cdot k}$

The increased cost comes from:
- Independent clustering for each view ($m \times$ Bartmip clustering cost)  
- Consensus step with $O(m^2 \cdot k_{\text{max}}^2)$ operations  
- Multi-view distance computations during transformation  
