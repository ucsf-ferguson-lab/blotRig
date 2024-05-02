# Welcome to blotRig!

## What is blotRig?

blotRig is a user-friendly interface is designed to facilitate appropriate counterbalancing, technical replication, and analysis of western blot experiments. This page will walk you through the installation and setup of the blotRig program in RStudio.

*Before you begin your blotRig setup, make sure you have the RStudio program installed on your computer*

To setup blotRig, it's easy as 1,2,3: **Download**, **Install**, and **Run** !

## Download blotRig

Click [HERE](https://github.com/ucsf-ferguson-lab/blotRig/archive/refs/heads/main.zip) to download blotRig to your computer. 
Unzip the file and save the `blotRig-main` folder wherever you would like. 

## Install blotRig 

Before you run blotRig for the first time, you will need to make sure RStudio has all the packages that blotRig uses. 
Simply open RStudio and copy and paste the following line of code into RStudio, and press 'Run'. This will download the source files and install the R libraries needed to run blotRig program.

```{r}
#install required R libraries
source("https://raw.githubusercontent.com/ucsf-ferguson-lab/blotRig/main/Setup/installdep.R")
```

## Run blotRig
Now that you have downloaded the blotRig folder to your computer and installed the necessary packages, it's time to run the program. Follow these steps to get going:

1. Navigate to the place on your computer where you saved the 'blotRig-main' folder and Open.
2. Click on the  `blotRig.Rproj` file. This will open in RStudio. 
3. Copy and paste the following lines of code into RStudio, and run them both:

```{r}
library(shiny)
shiny::runApp()
```
Now you're ready to go! You can use blotRig to design western blot experiments, create counter-balanced gel maps, and analyze your data once collected. 
In the future, when you want to use the blotRig program, just follow these 'Run blotRig' steps.

## Links
For more information and/or view source code, visit: [blotRig repo](https://github.com/ucsf-ferguson-lab/blotRig)
|Description|Link|
|---|---|
|Repo|https://github.com/ucsf-ferguson-lab/blotRig|
|Releases|https://github.com/ucsf-ferguson-lab/blotRig/releases/|
|Publication|-|
