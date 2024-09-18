# StiffCalc
This repository contains the StiffCalc model, which predicts tumor matrix stiffness based on aligned RNA-seq read counts.

## Overview
StiffCalc determines tumor rigidity (stiff or soft) by processing RNA-seq data. This tool is optimized for large-scale tumor studies and outputs categorical stiffness predictions for each sample.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisite Packages

* This package is supported for *Linux* operating systems.  The package has been tested on the following systems:
```
   Linux: Ubuntu 18.04.4 LTS
```   
* R version 4.3.2 is required.
	* [R 4.3.2 download](https://cran.r-project.org/src/base/R-4/R-4.3.2.tar.gz)

* Conda is required.
	
* R packages required in StiffCalc.
	* glmnet
	* optparse
	
### Installation of StiffCalc standalone program

To obtain StiffCalc, clone the repository from GitHub:

* Download StiffCalc from GitHub:
```
	git clone https://github.com/wang-lab/StiffCalc.git
```

* Install StiffCalc using Conda:
```
	conda env create -f StiffCalc.yaml
	conda activate stiffcalc
```

## Usage

### Run StiffCalc on command line

* You can run StiffCalc using the following command:
   
```
	Rscript StiffCalc.r -i [input file] -o [output file]
```

### PInput and Output File Descriptions

#### Inputs  
***-i [input file]***  
The input is a gene read counts file in TPM (transcripts per million) format. The file should have gene symbols as row names and sample names as column headers.

Example input format:
```  
	Symbol	Sample1	Sample2	Sample3	Sample4	Sample5	Sample6
	METTL25	101	116	127	141	122	118
	C3orf79	2	0	1	0	0	1
	THOC3	934	1043	794	921	871	829
	AHI1	919	941	1033	908	802	769
	SNX27	832	885	986	886	873	907
```  

***-o [output file]***  
The output is a file with stiffness predictions (soft or stiff) for each sample.

Example output format:
```  
		Sample1	Sample2	Sample3	Sample4	Sample5	Sample6
	Sample1	soft
	Sample2	stiff
	Sample3	soft
``` 

### Example
To test StiffCalc, an example input file is available at data/test.txt. Run the following command to generate the prediction:
```  
	Rscript StiffCalc.r -i data/test.txt -o results/prediction.txt
```  
An output file will be generated under results/prediction.txt.

License under the [GNU public library](LICENSE)