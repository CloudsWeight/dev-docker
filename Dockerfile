FROM kalilinux/kali-rolling

ARG USERNAME=pentester #change to your preference
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://kali.download/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list

RUN apt-get update && apt-get -y full-upgrade && \
    apt-get install -y --no-install-recommends \
        sudo vim nano tmux git curl wget ca-certificates gnupg less \
        net-tools iproute2 iputils-ping netdiscover \
        build-essential cmake pkg-config \
        python3 python3-pip python3-venv python3-dev pipx \
        nodejs npm \
        kali-tools-top10 \
        burpsuite zaproxy \
        ettercap-graphical bettercap \
        wireshark tshark tcpdump \
        iw wireless-tools aircrack-ng \
        tightvncserver dbus-x11 xfonts-base\
        xfce4 xfce4-terminal xfce4-goodies firefox-esr xterm \
        novnc websockify \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/opt/rustup CARGO_HOME=/opt/cargo PATH=/opt/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path \
    && chmod -R a+w /opt/rustup /opt/cargo

RUN groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && usermod -aG sudo,wireshark ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && setcap cap_net_raw,cap_net_admin+eip /usr/bin/nmap \
    && setcap cap_net_raw,cap_net_admin+eip /usr/sbin/ettercap || true \
    && setcap cap_net_raw,cap_net_admin+eip /usr/bin/bettercap || true \
    && setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap || true

USER ${USERNAME}
RUN python3 -m venv /home/${USERNAME}/venv && \
    /home/${USERNAME}/venv/bin/pip install --upgrade pip wheel && \
    /home/${USERNAME}/venv/bin/pip install \
        requests pwntools mitmproxy scapy impacket

ENV PATH="/home/${USERNAME}/venv/bin:/home/${USERNAME}/.cargo/bin:${PATH}"

USER root
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh
USER ${USERNAME}

WORKDIR /home/${USERNAME}/workspace
VOLUME ["/home/pentester/workspace"]

ENTRYPOINT ["/bin/bash"]
