# CasaOS Docker

这是一个为 [CasaOS](https://github.com/IceWhaleTech/CasaOS) 创建的 Docker 镜像, 用户可以通过简单的一键命令快速启动 CasaOS 实例. 

## 使用

```
docker-compose up -d
```

## 免责声明

- 为了确保构建镜像的稳定性, 我下载了 CasaOS 的安装脚本和包, 而不是构建时从网络下载, 避免依赖的外部资源变化导致无法构建镜像. 
  - casaos-install 文件夹内包即含 CasaOS 项目发布的安装包和脚本文件. 这些文件受原协议保护, 请遵循相关许可协议使用. 
  - 请注意, 这些文件可能较大, 并且所使用的版本可能不是最新的. 如需安装最新版本或有其他需要, 请自行修改 dockerfile 文件. 
- CasaOS 使用了 systemd 作为服务管理器, 但 docker 上运行 systemd 可能出现各种问题, 请谨慎使用. 
