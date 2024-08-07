#'find & show any duplicated subjects
#'inputDF = dataframe, show="all" to show all subjects (default), show="dupes" for duplicates only
findDupes <- function(inputDF,show="all"){
  temp <- data.frame(
    allNames=as.vector(t(inputDF)),
    dupe=NA
  )
  temp$dupe <- as.character(duplicated(temp$allNames))
  
  #show==dupes will only show duplicates
  if(show=="all"){
    return(temp)
  }else if(show=="dupes"){
    temp <- temp %>% dplyr::filter(dupe==TRUE)
    return(temp)
  }else{
    stop("Options for `show` are: all or dupes.")
  }
}

#'duplicated subject names in console output
#'outputs 0 if no duplicates found
listDupes <- function(inputDF){
  temp <- as.vector(
    t(
      findDupes(inputDF,show="dupes") %>% 
        dplyr::select(-dupe)
    )
  )
  if(length(temp)==0){
    temp <- 0
  }
  return(temp)
}

#create gel template
gelTemplate <- function(numLanes){
  #create template
  temp_gel <- as.data.frame(
    t(
      data.frame(
        colNum=1:numLanes,
        values=NA
      )
    )
  ) %>%
    dplyr::slice(-1)
  
  #fix row & col labels
  rownames(temp_gel) <- NULL
  return(temp_gel)
}

#'calculate min num gels required to fit all samples
#'numLanes-1 to account for ladder (assume can fit all on single gel)
minGels <- function(numLanes,numGroups,perGroup){
  temp <- ceiling(
    (numGroups*perGroup)/(numLanes-1)
  )
  return(temp)
}

#create baseline gel
gelBaseline <- function(totalSamples,perLine,entryID){
  #create template (assume single row)
  tempDF <- gelTemplate(totalSamples)
  tempDF[1,] <- entryID
  
  #create list of multiples
  cutpoints <- seq(1,totalSamples,perLine)
  
  if(length(cutpoints)!=1){
    #shift cols
    for(i in 2:length(cutpoints)){
      Lremainder <- totalSamples-perLine*(i-1)
      tempDF[i,1:Lremainder] <- tempDF[i-1,cutpoints[2]:ncol(tempDF)]
    }
    
    #rm extra info
    tempDF[,cutpoints[2]:ncol(tempDF)] <- NA
    
    #add ladder as col1
    tempDF <- tempDF[,-((cutpoints[2]):ncol(tempDF))] %>%
      dplyr::mutate(ladder="Ladder") %>%
      dplyr::relocate(ladder,.before=1)
  }else{
    tempDF <- tempDF %>%
      dplyr::mutate(ladder="Ladder") %>%
      dplyr::relocate(ladder,.before=1)
  }
  
    ## Add gel numbers
  rownames(tempDF)<-paste("Gel", 1:nrow(tempDF),sep = " ")
  
  return(tempDF)
}

#add cols to match set criteria
addCols <- function(inputDF,numLanes){
  #add NA cols till ncol(inputDF)=numLanes
  if(ncol(inputDF)<numLanes){
    startPoint <- ncol(inputDF)+1
    inputDF[,startPoint:numLanes] <- NA
  }
  
  #convert names to Lane #
  names(inputDF) <- paste("Lane",1:ncol(inputDF),sep=" ")
  return(inputDF)
}

#'center the samples (not including ladder)
centerSamples <- function(inputDF){
  #find num NA per row
  dfNA <- numNA(inputDF)
  
  #'can't center or no centering req
  if(nrow(dfNA)==1){
    #'inputDF <- inputDF is not a good idea bcuz making extra copy, thus wasting memory
  }else{
    naIndex <- index_temp(inputDF)
    
    #if there are NA cols
    if(nrow(naIndex)>=2){
      inputDF <- index_val(inputDF) %>%
        right_shift(inputDF)
    }
  }
  return(inputDF)
}

#find all NA index in inputDF (used in centerSamples)
index_temp <- function(inputDF){
  temp <- which(is.na(inputDF),arr.ind=TRUE) %>%
    as.data.frame()
  return(temp)
}

#find num NA per row (used in centerSamples)
numNA <- function(gelDF){
  temp <- colSums(is.na(gelDF)) %>%
    as.data.frame() %>%
    dplyr::filter(.==nrow(gelDF))
  rownames(temp) <- NULL
  names(temp) <- "Check"
  
  return(temp)
}

#create index of NA start/end (used in centerSamples)
index_val <- function(gelDF){
  naIndex <- list()
  
  #prepare for inner_join
  naIndex[["orig"]] <- index_temp(gelDF)
  naIndex[["copy"]] <- index_temp(gelDF) %>%
    dplyr::filter(duplicated(col)) 
  
  #det how many cols to shift by
  naIndex_temp <- dplyr::inner_join(naIndex$orig,naIndex$copy,by="col") %>%
    dplyr::select(-row.y) %>%
    dplyr::mutate(nastart=min(col),
                  nastop=max(col)) %>%
    dplyr::mutate(lengthNA=nastop-nastart+1,
                  gap=floor(lengthNA/2))
  
  #rm repeats
  naIndex_v1 <- naIndex_temp[1:nrow(gelDF),]
  
  return(naIndex_v1)
}

#perform shift aka centering (used in centerSamples)
right_shift <- function(naIndex,inputDF){
  for(i in 1:nrow(naIndex)){
    temp <- as.list(inputDF[i,]) %>% 
      unlist() %>%
      append(rep(NA,naIndex$gap[i]),after=1) %>% #shift everything after Ladder over by gap
      head(-naIndex$gap[i]) #rm same amount NA from end of list
    
    #overwrite lane in inputDf
    inputDF[i,] <- temp
  }
  return(inputDF)
}

#'takes all samples vector & drops all NA values
#'can pass result into length() for actual number of samples
actualNumSamples <- function(totalSamples){
  temp <- totalSamples[!is.na(totalSamples)]
  return(temp)
}

#'shift all samples to left if lane is empty (aka group is missing samples or unequal num samples per group)
shiftLanes <- function(inputDF){
  for(i in 1:nrow(inputDF)){
    #rm NA
    temp <- inputDF[i,] %>%
      unlist()
    tempItem <- temp[!is.na(temp)]
    
    #replace row w/ new list
    inputDF[i,] <- NA
    inputDF[i,1:length(tempItem)] <- tempItem
  }
  return(inputDF)
}

#'convert centeredGel into template for user to fill in quant
templateOutput <- function(inputGel){
  elist <- apply(inputGel,1,function(row) as.data.frame(t(row))) %>%
    lapply(function(x){
      #transpose
      temp <- x %>%
        t() %>%
        as.data.frame()
      
      #add lane num as col 1
      temp <- temp %>%
        dplyr::mutate(LaneNum=rownames(temp)) %>%
        dplyr::relocate(LaneNum,.before=1)
      rownames(temp) <- NULL
      
      #return
      temp
    }) 
  
  #add gel number (based on row num from centered inputGel)
  elist <- lapply(1:length(elist),function(x){
    temp <- elist[[x]] %>%
      dplyr::mutate(Gel_Number=x)
  }) %>%
    bind_rows() %>%
    
    #convert to sample template output
    dplyr::mutate(
      TechnicalRep=NA,
      Quant=NA,
      LoadQuant = NA
    ) %>%
    dplyr::relocate(c(V1,TechnicalRep),.before=1) %>%
    dplyr::filter(!is.na(V1))
  
  #rename colnames (always the same)
  names(elist) <- c("Sample_ID","Technical_Replication","Lane",
                    "Gel_Number","Protein_Quant", "Load_Control_Quant")
  return(elist)
}

#fill in groups from sourceDF
matchNfill <- function(sourceDF,finalDF){
  temp <- sourceDF %>%
    tidyr::pivot_longer(cols=(1:ncol(sourceDF)),
                        names_to="Group",
                        values_to="Sample_ID") %>%
    dplyr::right_join(finalDF,by="Sample_ID") %>%
    dplyr::relocate(Group,.after=Sample_ID) %>%
    dplyr::mutate(Group=ifelse(Sample_ID=="Ladder","Ladder",Group)) #replace NA w/ Ladder in Group col
  return(temp)
}

#'duplicate x number of times (based on user input of how many technical replications)
techRep <- function(inputDF,numReps){
  temp <- lapply(1:numReps,function(x){
    inputDF %>%
      dplyr::mutate(Technical_Replication=x) #add technical rep
  }) %>%
    bind_rows() #combine all together
  return(temp)
}

#'create finalized template (glues all other functions together)
#'create template from inputGel (centered gel)
#'fill in groups from sourceDF
#'num of technical replications (default=1)
#'sort (rep,gel) 
#'  nchar(lane) before lane = 1,2,3... before 10
#'reorder
finalizedDF <- function(inputGel,sourceDF,numReps=1){
  temp <- inputGel %>%
    templateOutput() %>%
    matchNfill(sourceDF=sourceDF) %>%
    techRep(numReps) %>%
    dplyr::arrange(Technical_Replication,Gel_Number,nchar(Lane),Lane) %>%
    dplyr::relocate(Gel_Number,.before=Technical_Replication)
  return(temp)
}

#'det num samples per line
perLine_logic <- function(numLanes,numGroups){
  if((numLanes-1)>=numGroups){
    temp <- floor(numLanes/numGroups)*numGroups
  }else{
    temp <- 0
  }
  return(temp)
}

#'placeholder for final generated template
template_placeholder <- function(){
  col_names <- c("Sample_ID","Group","Gel_Number","Technical_Replication",
                 "Lane","Protein_Quant")
  
  temp <- data.frame(
    matrix(NA,nrow=1,ncol=length(col_names),dimnames=list(NULL,col_names)),
    stringsAsFactors=FALSE
  )
  return(temp)
}
