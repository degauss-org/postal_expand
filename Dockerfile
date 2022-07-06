 FROM rocker/r-ver:4.1.3
# FROM golang:1.17.8-buster

# # DeGAUSS container metadata
ENV degauss_name="postal"
ENV degauss_version="0.1.0"
ENV degauss_description="normalized and parsed addresses"
# ENV degauss_argument="short description of optional argument [default: 'insert_default_value_here']"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"


ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update \
        && apt-get install -yqq --no-install-recommends \
        autoconf \
        automake \
        libtool \
        curl \
        pkg-config \
        git \
        make \
        && apt-get clean

RUN git clone https://github.com/openvenues/libpostal --branch "v1.1" /code/libpostal
WORKDIR /code/libpostal
RUN ./bootstrap.sh
RUN mkdir -p /opt/libpostal_data
RUN ./configure --datadir=/opt/libpostal_data
RUN make -j4
RUN make install
RUN ldconfig -v
RUN pkg-config --cflags libpostal
#   download data    ¯\_(ツ)_/¯
WORKDIR /opt/libpostal_data/libpostal
ADD https://github.com/openvenues/libpostal/releases/download/v1.0.0/language_classifier.tar.gz .
RUN tar -xvzf language_classifier.tar.gz && rm language_classifier.tar.gz
ADD https://github.com/openvenues/libpostal/releases/download/v1.0.0/libpostal_data.tar.gz .
RUN tar -xvzf libpostal_data.tar.gz && rm libpostal_data.tar.gz
ADD https://github.com/openvenues/libpostal/releases/download/v1.0.0/parser.tar.gz .
RUN tar -xvzf parser.tar.gz && rm parser.tar.gz

WORKDIR /app
RUN R --quiet -e "install.packages('remotes', repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"
RUN R --quiet -e "remotes::install_github('rstudio/renv@0.15.4')"
COPY renv.lock .
RUN R --quiet -e "renv::restore(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"
COPY entrypoint.R .
WORKDIR /tmp
ENTRYPOINT ["/app/entrypoint.R"]


