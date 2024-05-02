# Welcome to blotRig!

## What is blotRig?

blotRig is a user-friendly interface is designed to facilitate appropriate counterbalancing, technical replication, and analysis of western blot experiments. This page will walk you through the installation and setup of the blotRig program in RStudio.

*Before you begin your blotRig setup, make sure you have the RStudio program installed on your computer*

For more information and/or view source code, visit: [blotRig repo](https://github.com/ucsf-ferguson-lab/blotRig)

## To Install blotRig

To get blotRig set up, simply copy and paste the following lines of code into RStudio, and run them. This will download the source files and install the R libraries needed to run blotRig program.

```{r}
#download repo
source("https://raw.githubusercontent.com/ucsf-ferguson-lab/blotRig/main/Setup/repodownload.R")

#install required R libraries
source("https://raw.githubusercontent.com/ucsf-ferguson-lab/blotRig/main/Setup/installdep.R")
```

## To Run blotRig
Now that the blotRig folder has been downloaded, it's time to run the program. Follow these steps to get going:

1. Open `blotRig-main` folder 
2. Click on the  `blotRig.Rproj` file. This will open in RStudio. 
3. Copy and paste the following lines of code into RStudio, and run them both:

```{r}
library(shiny)
shiny::runApp()
```
Now you're ready to go! You can use blotRig to design western blot experiments, create counter-balanced gel maps, and analyze your data once collected. 

## Links

|Description|Link|
|---|---|
|Repo|https://github.com/ucsf-ferguson-lab/blotRig|
|Releases|https://github.com/ucsf-ferguson-lab/blotRig/releases/|
|Publication|-|
