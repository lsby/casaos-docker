FROM debian:bullseye

SHELL ["/bin/bash", "-c"]

# 复制安装包
# get.casaos.io.sh.bak 来自于 https://get.casaos.io (2024年11月1日)
# 该安装脚本中多次使用了 systemctl, 但构建环境中无法以 pid=1 启动 systemd, 所以要对安装脚本做一些处理
# get.casaos.io.sh 是基于 get.casaos.io.sh.bak 修改后的脚本
# casaos-pkg 文件夹内的内容来自于 get.casaos.io.sh 脚本中的下载地址 (2024年11月1日)
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
        systemd \
        systemd-sysv \
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

# 复制自检脚本并创建服务
# self-check.sh 脚本将检查 casaos 的必要服务是否启动, 该脚本基于 get.casaos.io.sh.bak 修改而成
# self-check.service 服务将在开机后自动启动, 并将结果输出到终端
COPY ./casaos-install/service/self-check/script.sh /usr/local/bin/self-check.sh
COPY ./casaos-install/service/self-check/service.service /usr/lib/systemd/system/self-check.service
RUN chmod +x /usr/local/bin/self-check.sh

# 复制数据目录初始化脚本并创建服务
# init-casaos-dir.sh 脚本将检查 casaos 的数据目录是否为空, 如果为空则复制最初的备份文件初始化
# 适用于将 casaos 的数据目录映射到 docker 外部的情况
# init-casaos-dir.service 服务将在开机后自动启动, 并将结果输出到终端
# COPY ./casaos-install/service/init-casaos-dir/script.sh /usr/local/bin/init-casaos-dir.sh
# COPY ./casaos-install/service/init-casaos-dir/service.service /usr/lib/systemd/system/init-casaos-dir.service
# RUN chmod +x /usr/local/bin/init-casaos-dir.sh

# 备份数据目录
# RUN cp -r /var/lib/casaos /var/lib/casaos-bak

# 告诉 systemd 它运行在容器内
ENV container=docker

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/lib/systemd/systemd"]
