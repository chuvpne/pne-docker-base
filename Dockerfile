FROM rocker/rstudio
MAINTAINER alexis rapin
RUN apt-get -y update && apt-get clean \
  && apt-get -y install \
    build-essential \
    libncurses5-dev \
    libncursesw5-dev \
    libxml2-dev \
    parallel \
    tk-dev \
    zlib1g-dev

# INSTALL PYTHON3.6
RUN cd /tmp \
  && wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz \
  && tar xvf Python-3.6.3.tgz \
  && cd Python-3.6.3 \
  && ./configure --enable-optimizations --with-ensurepip=install \
  && make -j8 \
  && make altinstall \
  && cd \
  && echo "alias python=python3.6" >> .bashrc

# INSTALL ILLUMINA-UTILS
RUN pip3.6 install illumina-utils

# INSTALL PACKRAT
RUN Rscript -e "install.packages(c('BiocManager', 'packrat'), dependencies=TRUE)"

