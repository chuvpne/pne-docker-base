FROM centos:centos7
MAINTAINER alexis rapin
RUN yum -y update && yum clean all \
  && yum -y groupinstall development \
  && yum -y install openssl \
    epel-release \
    initscripts \
    wget \
    git \
    libcurl-devel \
    libxml2-devel \
    openssl-devel \
  && yum -y install R-core \
    R-base \
    R-devel \
  && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
  && yum -y install python36u \
    python36u-devel \
    python36u-pip \
    parallel \
  && echo "alias python=python3.6" >> .bashrc

# INSTALL RSTUDIO SERVER
RUN wget https://download2.rstudio.org/rstudio-server-rhel-1.1.463-x86_64.rpm \
  && yum -y install rstudio-server-rhel-1.1.463-x86_64.rpm \
  && rm -f rstudio-server-rhel-1.1.463-x86_64.rpm

# CREATE RSTUDIO SERVER USER
RUN useradd -d /home/rstudio -ms /bin/bash -p $(openssl passwd -1 -salt $(openssl rand -base64 6) rstudio) rstudio
WORKDIR /home/rstudio

# INSTALL PACKRAT
RUN echo "options(repos=structure(c(CRAN='https://stat.ethz.ch/CRAN')))" >> .Rprofile \
  && echo ".libPaths('/usr/share/R/library')" >> .Rprofile \
  && Rscript -e "install.packages(c('BiocManager', 'packrat'), dependencies=TRUE)"

# INSTALL ILLUMINA-UTILS
RUN pip3.6 install illumina-utils
