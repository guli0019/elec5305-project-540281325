# Speech Gender Classification Using MFCC and Pitch Features (ELEC5305 Project)

**Student:** Guanzhen Li (SID: 540281325, Unikey: guli0019)  
**Course:** ELEC5305 – Acoustics, Speech and Signal Processing, The University of Sydney  

This repository contains the MATLAB code and key result figures for my ELEC5305 project on **speech-based gender classification**.  
The project investigates how MFCC dimensionality, the use of pitch, classifier choice, and additive noise affect the performance of a simple supervised gender classifier.

---

## 1. Research Question

> Can we classify the gender of a speaker from clean and noisy speech using MFCC and pitch features with a simple classifier, and how do feature design and classifier choice influence the performance?

More specifically, the project studies:

- The effect of **MFCC dimensionality** (8 vs 13 vs 39 coefficients),
- The benefit of adding **pitch (F0)** on top of MFCCs,
- The performance difference between **SVM and k-NN** classifiers,
- The **robustness to additive white noise** at 10 dB SNR.

The written report (submitted separately to Canvas) provides full experimental details and discussion.

---

## 2. Dataset

The experiments use the **Free ST American English Corpus** (OpenSLR SLR45):

- OpenSLR page: <https://www.openslr.org/45/>

In this project:

- Only a subset of speakers and files is used.
- File names starting with `m` are treated as **male**, and `f` as **female**.
- Audio is resampled to 16 kHz mono.
- An 80/20 utterance-level split is used for training and testing.

> Note: The dataset itself is **not included** in this repository.  
> Please download SLR45 from OpenSLR and adjust the `datasetPath` variable in the code to point to your local copy.

For example:

```matlab
datasetPath = 'E:\Matlab Project\ELEC5305 Final Project\Dataset';
