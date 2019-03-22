FROM ubuntu:18.10

EXPOSE 9091 \
       51413/tcp \
       51413/udp \
       46882/udp \
       50052/udp

USER root
WORKDIR /root

ENV ULTIMATE_BLOCKLIST https://github.com/walshie4/Ultimate-Blocklist.git
ENV BLOCKLIST_PATH /root/.config/transmission/blocklists

RUN apt-get update &&\
    apt-get install -y \
        ca-certificates \
        emacs-goodies-el \
        emacs25-nox \
        ffmpeg \
        git \
        language-pack-en \
        nano \
        python \
        python-pip \
        python3 \
        transmission-cli &&\
    pip install \
        ipython \
        virtualenv \
        youtube_dl

RUN git clone https://gitlab.com/initbar/dotfiles.git /root/.lib &&\
    cd /root/.lib && git submodule update --init --recursive

RUN mkdir -p /root/.emacs.d &&\
    ln -sf /root/.lib/internal/cli/emacs/emacs.el /root/.emacs &&\
    ln -sLf /root/.lib/internal/cli/emacs/custom /root/.emacs.d/custom

RUN mkdir -p ${BLOCKLIST_PATH} && \
    git clone ${ULTIMATE_BLOCKLIST} /tmp/Ultimate-Blocklist && \
    pip install -r /tmp/Ultimate-Blocklist/requirements.txt && \
    python /tmp/Ultimate-Blocklist/UltimateBlockList.py && \
    mv blocklist.txt ${BLOCKLIST_PATH}/$(date +%F).txt && \
    rm -rf /tmp/Ultimate-Blocklist
