## Malicious-Url-Detection Using Machine Learning And Deep Learning Cloud Architecture

![fastbid-model - Page 1](https://user-images.githubusercontent.com/74520811/136707817-a4b160c1-8e6d-4487-b571-9e6994dd14ad.png)

## Overview
Fraudsters send fake emails or set up fake web sites that mimic Yahoo!'s sign-in pages (or the sign-in pages of other trusted companies, such as eBay or PayPal) to trick you into disclosing your user name and password. This practice is sometimes referred to as "phishing" — a play on the word "fishing" — because the fraudster is fishing for your private account information.

## Problem Defintion

A machine learning and Deep Learning model to detect malicious urls to prevent phising.

## Socre
* **Accuracy Score:  96**
* **Precission:  97**
* **f1 score:  96**
* **recall:  95**

## Tools
* Docker
* Python(FastAPI)

## Deployment
An API was created using Python FastAPI and was deployed on **Google** Cloud Platform taking advantage of its CloudRun and Storage Buckect. The entire deployment was automated using Google Cloud CLI. 

**Note** Give permision to execute the file `scripts.sh` using `chmod +x scripts.sh`. Run the script by typing `./scripts.sh` to deploy the application

## **Algorithms Used**
#### Machine Learning
* NaiveBayes
* LogisticRegression

#### Revolutional Neural Networks
* LSTM
* Embedding
* GRU
* Bidirectional
* Conv1D
* Transfere Learning techniques

### **Evaluation Metrics Used**
* Accuracy score
* F1 score
* Precision
* Recall
* Confusion matrics
* Classification report
