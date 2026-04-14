Here’s a more concise version of your project write‑up, keeping the essentials intact:

---

# MRI Reconstruction: CS + Deep Learning (MATLAB)

## 📌 Overview
Hybrid pipeline for **fast MRI reconstruction** using:
- **Compressed Sensing (CS, FISTA)** for initial recovery  
- **Residual U-Net** for refinement  
- **Uncertainty Estimation** for reliability  

---

## 🚀 Features
- k-space undersampling simulation  
- CS reconstruction (FISTA + TV)  
- Residual U-Net enhancement  
- PSNR/SSIM evaluation  
- Uncertainty maps  
- MATLAB GUI  

---

## 🧠 Pipeline
```
DICOM → Preprocess → Undersample
      → Zero-fill → CS (FISTA)
      → U-Net → Sharpen → Output + Metrics + Uncertainty
```

---

## 📁 Structure
```
matlab_1/
├── run_pipeline.m
├── setup_project.m
├── generate_training_data.m
├── train_model.m
├── evaluate_model.m
├── +cs/ (sampling, FISTA, TV)
├── +dl/ (U-Net, uncertainty)
├── +utils/ (I/O, metrics)
├── +gui/ (MRI_App.mlapp)
├── data/ models/ outputs/
```

---

## ⚙️ Requirements
- MATLAB R2025b+  
- Image Processing, Deep Learning, Signal Processing Toolboxes  

---

## ▶️ Run Steps
```matlab
cd('matlab_1'); setup_project
generate_training_data(100)
train_model
evaluate_model
run_pipeline
gui.MRI_App
```

---

## 📊 Results
| Method | PSNR (dB) | SSIM |
|--------|-----------|------|
| CS     | ~23.5     | ~0.61 |
| AI     | 24–26     | 0.60–0.75 |

AI improves quality; uncertainty maps highlight unreliable regions.

---

## 🧩 Techniques
- FFT/IFFT MRI simulation  
- CS (FISTA + TV)  
- Residual U-Net  
- Unsharp Masking  
- Monte Carlo uncertainty  

---

## 🎯 Applications
- Fast MRI scanning  
- Medical image reconstruction  
- AI-assisted diagnostics  

---

## 📌 Future Work
- Larger datasets  
- Deeper U-Net  
- GPU real-time inference  
- 3D MRI reconstruction  

---

## 👤 Author
**Sai Manoj Adavi**  
Domain: Embedded Systems + AI  

---

This shortened version keeps the technical depth but trims repetition and detail. Would you like me to make an even more compact “one‑page summary” style version for presentations?
