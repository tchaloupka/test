FROM alpine:3.7

# Note: Change asciidoctor version in version.txt too as it is used as a tag for built image by CI
ARG asciidoctor_version=1.5.8
ARG asciidoctor_pdf_version=1.5.0.alpha.16
ARG asciidoctor_epub3_version=1.5.0.alpha.8
ARG vega_version="v4.3.0"

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
    ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
    VEGA_VERSION=${vega_version}

# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    findutils \
    font-bakoma-ttf \
    graphviz \
    inotify-tools \
    make \
    openjdk8-jre \
    py2-pillow \
    py-setuptools \
    python2 \
    ruby \
    ruby-mathematical \
    ttf-liberation \
    unzip \
    which \
    cairo \
    jpeg \
    giflib \
    nodejs

# Installing Vega
RUN apk add --no-cache --virtual .vegadepends \
    python cairo-dev jpeg-dev giflib-dev g++ yarn git \
    && git clone https://github.com/vega/vega.git -b "${VEGA_VERSION}" \
    && cd vega && yarn && yarn build && yarn install \
    && ln -s /vega/bin/vg2* /usr/local/bin/ \
    && rm -rf docs \
    && apk del -r --no-cache .vegadepends

# Installing Ruby Gems needed in the image
# including asciidoctor itself
RUN apk add --no-cache --virtual .rubymakedepends \
    build-base \
    libxml2-dev \
    ruby-dev \
 && gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    asciidoctor-confluence \
    asciidoctor-diagram \
    "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
    asciidoctor-mathematical \
    asciimath \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    asciidoctor-revealjs \
    coderay \
    epubcheck:3.0.1 \
    haml \
    kindlegen:3.0.3 \
    pygments.rb \
    rake \
    rouge \
    slim \
    thread_safe \
    tilt \
 && apk del -r --no-cache .rubymakedepends

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    python2-dev \
    py2-pip \
 && pip install --upgrade pip \
 && pip install --no-cache-dir \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    Pygments \
    seqdiag \
 && apk del -r --no-cache .pythonmakedepends

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
