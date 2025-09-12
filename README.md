# Tone-First Mandarin Pronunciation Feedback System

**Course:** ELEC5305 – Acoustics, Speech and Signal Processing  
**Student:** Guanzhen Li · **SID:** 540281325 · **GitHub:** @guli0019

## Overview
This project provides Mandarin tone feedback at both sentence and character levels. 
Given read speech and a reference text, it extracts F0 contours, matches each syllable 
to multi-speaker tone templates, and produces a 0–1 tone-correctness score with clear visuals.

## Demo (GitHub Pages)
[<https://<your-username>.github.io/elec5305-project-<SID>/>](https://github.com/guli0019/elec5305-project-540281325)
> Per the course guide, this link is also included in the proposal PDF.

## Repository Structure
/proposal/ # Project proposal PDF
/notebooks/ # Analysis and prototypes (optional)
/src/ # Core scripts (optional)
/data/ # Small sample data or links (no large files)
/docs/ # Optional static assets for Pages

## Quick Start
- Open the notebooks or run the scripts in `/src` to reproduce basic tone scoring.
- Outputs (per-syllable scores, sentence score, F0 JSON) are stored under `/outputs`.

## References (≥3 peer-reviewed)
1. Witt & Young (2000), *Speech Communication* — phone-level pronunciation scoring.  
2. McAuliffe et al. (2017), *Interspeech* — Montreal Forced Aligner (alignment background).  
3. Mauch & Dixon (2014), *ICASSP* — pYIN pitch estimation.  
4. Tone Perfect (MSU Libraries) — native monosyllable tone corpus.

## Submission Checklist
- [ ] Public repo created and proposal PDF uploaded  
- [ ] README completed  
- [ ] GitHub Pages enabled and URL added to the PDF  
