FROM rocker/verse:4.1.0

# system libraries of general use
## install debian packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libfontconfig1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    coinor-libcbc-dev \
    libudunits2-dev \
    libgeos-dev \
    coinor-libclp-dev \
    libgsl-dev \
    libgdal-dev \
    libxt-dev \
    libglpk-dev

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Install R packages (https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file)
RUN install2.r --error \
    httr \
    Cairo \
    plotly \
    Rfast \
    BiocManager \
    devtools

# RUN R -e "install.packages(c('stringr', \
#                             'reshape2', \
#                             'plyr', \
#                             'caret', \
#                             'ggplot2', \
#                             'devtools'), dependencies=TRUE, repos='http://cran.studio.com/')"

# example installing package from github using devtools
RUN R -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'limma', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment', 'batchelor', 'Matrix.utils'))"
RUN R -e "BiocManager::install('multtest')"
RUN R -e "devtools::install_github('Vivianstats/scImpute')"
RUN R -e "remotes::install_github('jlmelville/uwot')"
RUN R -e "remotes::install_github('satijalab/seurat', ref = 'release/4.1.0')"
RUN R -e "remotes::install_github('kharchenkolab/pagoda2')"
RUN R -e "install.packages('devtools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('cole-trapnell-lab/leidenbase')"
RUN R -e "devtools::install_github('cole-trapnell-lab/monocle3')"
RUN R -e "BiocManager::install('SingleR')"
RUN R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')"

# example installing package from folder
# make sure folder is in same directory as Dockerfile
# install.packages("/my/dir/package.tar.gz",repos=NULL, type="source")