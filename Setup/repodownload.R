#'download GH repo
  #'download file -> unzip -> rm zip
dl_file <- function(){
  filename <- "blotRig.zip"
  download.file(
    url="https://github.com/ucsf-ferguson-lab/blotRig/archive/refs/heads/main.zip",
    destfile=filename
  )
  unzip(zipfile=filename)
  file.remove(filename)
}

#prompt user for username
username <- NA
while(is.na(username) | username=="" | username==" "){
  username <- readline("Enter your username: ")
}

#download GH repo, accounts for diff path separator in macOS vs Windows
if(!is.na(username)){
  user_os <- Sys.info()["sysname"]
  
  if(user_os=="Darwin"){
    desktop <- paste("/Users",username,"Desktop",sep="/")
    setwd(dir=desktop)
    dl_file()
    cat("blotRig repo has been downloaded to: ",desktop,sep="")
  }
  
  if(user_os=="Windows"){
    desktop <- paste("C:","Users",username,"Desktop",sep="\\")
    setwd(dir=desktop)
    dl_file()
    cat("blotRig repo has been downloaded to: ",desktop,sep="")
  }
}
