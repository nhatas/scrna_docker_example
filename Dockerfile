FROM rocker/verse:4.0.3

# system libraries of general use
## install debian packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    build-essential \
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
    libgeos-dev \
    libproj-dev \
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
    devtools \
    remotes \
    Seurat \
    pagoda2 \
    BiocManager \
    uwot \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# install packages from Bioconductor
RUN R -e 'requireNamespace("BiocManager"); BiocManager::install(c("BiocGenerics", "DelayedArray", "DelayedMatrixStats", "limma", "S4Vectors", "SingleCellExperiment", "SummarizedExperiment", "batchelor", "Matrix.utils", "multtest", "SingleR"));' \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# install packages from GitHub
RUN R -e "remotes::install_github('cole-trapnell-lab/leidenbase')"
RUN R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')"
RUN R -e 'devtools::install_github("cole-trapnell-lab/monocle3")'

# try to manually install monocle3
# WORKDIR /app
# RUN git clone https://github.com/cole-trapnell-lab/monocle3.git
# RUN R -e 'install.packages("/app/monocle3", repos = NULL, type = "source")'
# RUN rm -rf /app/monocle3


ENTRYPOINT ["/bin/bash"]