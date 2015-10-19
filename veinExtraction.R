# vein_extraction_R
#using R and EBImage package to extract vein pattern in grayscale image

source("http://bioconductor.org//biocLite.R")
biocLite()
biocLite("EBImage")

#select EBImage in RStudio packages
#place the image under "images" where your EBImage package is saved: ~\R\win-library\3.2

system.file(package="EBImage")
f=system.file("images","finger_vein_closeup.jpg",package="EBImage")
GE=readImage(f)
display(GE)
print(GE)

#play around to see different manipulations

#brightness
GE1<-GE+0.2
GE2<-GE-0.2
display(GE1);display(GE2)


#contrast
GE3<-GE*0.5
GE4<-GE*2
display(GE3);display(GE4)


#gamma correction
GE5 <- GE ^ 2
GE6 <- GE ^ 0.7
display(GE5); display(GE6)


#filtering
#low-pass (blur)
fLow <- makeBrush(21, shape= 'disc', step=FALSE)^2
fLow <- fLow/sum(fLow)
GE.fLow <- filter2(GE, fLow)
display(GE.fLow)

#high pass
fHigh <- matrix(1, nc = 3, nr = 3)
fHigh[2, 2] <- -8
GE.fHigh <- filter2(GE, fHigh)
display(GE.fHigh)

#median filter
medFltr <- medianFilter(GE, 1.1)
display(medFltr)


# extract the blue channel
GE.data <- imageData(channel(GE4, mode = "blue"))
GE.data <- 1 - GE.data  # reverse the image 
hist(GE.data)

# noticed that the background is under 0.3, while the vein above
GE.data[GE.data < .3] <- 0
GE.data[GE.data >= .3] <- 1
GE.lab <- bwlabel(GE.data)  # attempt to enclose the holes
GE.lab <- fillHull(GE.lab)  
#kern <- makeBrush(3, shape = "disc", step = F)
#GE.lab <- erode(GE.lab, kern)  # remove only a few noisy pixels


## compute binary mask
y = thresh(GE.lab, 10, 10, 0.05)
y = opening(y, makeBrush(3, shape='disc'))
if (interactive()) display(y, title='Vain binary mask')
