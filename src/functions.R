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

#duplicated subject names in console output
listDupes <- function(inputDF){
  as.vector(
    t(
      findDupes(inputDF,show="dupes") %>% 
        dplyr::select(-dupe)
    )
  )
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
  names(temp_gel) <- stringr::str_replace(
    names(temp_gel),"V","Lane "
  )
  
  return(temp_gel)
}

#'calculate min num gels required to fit all samples
#'numLanes-1 to account for ladder
minGels <- function(numLanes,numGroups,perGroup){
  temp <- ceiling(
    (numGroups*perGroup)/(numLanes-1)
  )
  return(temp)
}

#'calculate num groups to push to next lane
groupRemainder <- function(numLanes,numGroups,perGroup){
  temp <- floor(
    ((numGroups*perGroup)+1)/numLanes
  )
  return(temp)
}

#'create start & stop points
createBreaks <- function(numLanes,numGroups,perGroup,totalSamples){
  index <- list()
  
  #num groups in next gel
  fornext <- groupRemainder(numLanes,numGroups,perGroup)
  
  #num samples per gel
  perGel <- numLanes-(fornext*perGroup)
  if(perGel<=perGroup+1){
    perGel <- perGroup+1
  }else{
    perGel <- perGel
  }
  
  # if(perGel>=0){
  #   perGel <- perGel
  # }else{
  #   perGel <- perGroup #smallest num that will still meet req
  # }
  
  #create breakpoints
  index <- seq(1,totalSamples,perGel)
  return(index)
}

#'subset samples into groups 
createGroups <- function(start,end){
  temp <- exDF_dupes$allNames[start:end] %>%
    # dplyr::select(-dupe) %>%
    unlist()
  return(temp)
}

#'create gel template, each row is a separate gel
gelOrder <- function(numLanes,numGroups,perGroup,subjectNames){
  #create temp df
  temp_gel <- gelTemplate(numLanes)
  
  #calculate min # gels req
  gels <- minGels(numLanes,numGroups,perGroup)
  
  #num samples (includes ladder)
  totalSamples <- (numGroups*perGroup)+gels
  
  #all samples + ladder fit on single gel
  if(totalSamples<=numLanes){
    temp_gel[1,1] <- "Ladder"
    temp_gel[1,2:(totalSamples+1)] <- subjectNames[1:totalSamples]
  }

  #multiple gels req
  else{
    temp_gel[1:gels,1] <- "Ladder"

    #det which samples are moved to next gel
    index <- createBreaks(numLanes,numGroups,perGroup,totalSamples)

    for(i in 1:gels){
      #not end gel
      if(i<gels){
        temp_gel[i,2:index[i+1]] <- createGroups(index[i],index[i+1])
      }
      #end gel (will be truncated)
      else{
        #1 for counting, 1 for displacement by ladder
        loc <- (length(subjectNames)-index[i])+2
        temp_gel[i,2:loc] <- createGroups(index[i],length(subjectNames))
      }
    }
  }
  
  return(temp_gel)
}
