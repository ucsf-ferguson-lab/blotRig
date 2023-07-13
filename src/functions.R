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
  #det if even/odd num full NA cols
  dfNA <-colSums(is.na(inputDF)) %>%
    as.data.frame() %>%
    filter(.==nrow(inputDF))
  rownames(dfNA) <- NULL
  names(dfNA) <- "Check"
  
  if(nrow(dfNA)%%2==1){ #odd num full NA cols -> no centering done
    #'no centering req (placeholder)
    #'inputDF <- inputDF is not a good idea bcuz making extra copy & thus wasting memory
  }else{
    naIndex <- which(is.na(inputDF),arr.ind=TRUE) %>%
      as.data.frame()
    
    #if there are NA cols
    if(nrow(naIndex)>0){
      naIndex <- naIndex %>%
        dplyr::filter(col==min(col)|col==max(col)) %>%
        aggregate(col~row,FUN=c) %>%
        dplyr::mutate(nastart=unlist(col[,1])) %>% #NA starts
        dplyr::mutate(nastop=unlist(col[,2])) %>% #NA ends (typically ncol(inputDF))
        dplyr::select(-col) %>%
        dplyr::mutate(lengthNA=nastop-nastart+1) %>% #add 1 for index
        dplyr::mutate(gap=floor(lengthNA/2)) #calculate gap to shift by
      
      for(i in 1:nrow(naIndex)){
        temp <- as.list(inputDF[i,]) %>% 
          unlist() %>%
          append(rep(NA,naIndex$gap[i]),after=1) %>% #shift everything after Ladder over by gap
          head(-naIndex$gap[i]) #rm same amount NA from end of list
        
        #overwrite lane in inputDf
        inputDF[i,] <- temp
      }
    }
  }
  return(inputDF)
}

#'takes all samples vector & drops all NA values
#'can pass result into length() for actual number of samples
actualNumSamples <- function(totalSamples){
  temp <- totalSamples[!is.na(totalSamples)]
  return(temp)
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
      Quant=NA
    ) %>%
    dplyr::relocate(c(V1,TechnicalRep),.before=1) %>%
    dplyr::filter(!is.na(V1))
  
  #rename colnames (always the same)
  names(elist) <- c("Sample_ID","Technical_Replication","Lane",
                    "Gel_Number","Protein_Quant")
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
