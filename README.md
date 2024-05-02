# Welcome to blotRig!

## What is blotRig?

blotRig is a user-friendly interface designed to facilitate appropriate counterbalancing, technical replication, and analysis of western blot experiments. This page will walk you through the installation and setup of the blotRig program in RStudio.

*Before you begin your blotRig setup, make sure you have the RStudio program installed on your computer*

## Install blotRig 

The following line of code will install blotRig along with it's dependencies.

```{r}
source("https://raw.githubusercontent.com/ucsf-ferguson-lab/blotRig/main/Setup/installdep.R")
```

## Run blotRig

To start blotRig, run the following lines of code:

```{r}
library(blotRig)
blotRig::start_blotrig()
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
