FROM debian:bullseye

SHELL ["/bin/bash", "-c"]

# 复制安装包
# bak/get.casaos.io.sh 来自于 https://get.casaos.io (2024年11月1日)
# 该安装脚本中多次使用了 systemctl, 但构建环境中无法以 pid=1 启动 systemd, 所以对安装脚本做一些处理, 修改后得到了 get.casaos.io.sh
# casaos-pkg 文件夹内的内容来自于源脚本中的下载地址 (2024年11月1日)
# 提供这些文件旨在确保构建镜像稳定, 不依赖于外部资源的变化.
COPY ./casaos-install/get.casaos.io.sh /tmp/get.casaos.io.sh
COPY ./casaos-install/casaos-pkg /tmp/casaos-installer

# 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        sudo \
        curl \
        wget \
        procps \
        lsb-release \
        docker.io \
        ca-certificates \
        smartmontools \
        parted \
        ntfs-3g \
        net-tools \
        udevil \
        samba \
        cifs-utils \
        mergerfs \
        unzip && \
    apt-get clean

# 执行安装
RUN sudo bash /tmp/get.casaos.io.sh

# 复制启动脚本
COPY ./casaos-install/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
