# 科学上网容器 #

科学上网容器·客户端。

## 端口说明 ##

|  类型  | 端口 |     说明     |
| :----: | :--: | :----------: |
| socks5 | 1080 |   SS 端口   |
|  http  | 8118 | Privoxy 端口 |
|  http  | 8123 | Polipo 端口  |

## 使用 ##

* 如需 socks5 类型的代理，则使用 `127.0.0.1:1080` （全局）
* 如需根据规则使用 http 类型的代理，则使用 `127.0.0.1:8118`
* 如需全局使用 http 类型的流量，则代理 `127.0.0.1:8123`

## 配置 ##

创建 json 文件，如： shadowsocks.json，写上自己的配置，比如：

```json
{
	"server": "your.server",
	"server_port": 7777,
	"local_address": "0.0.0.0",
	"local_port": 1080,
	"password": "12345678",
	"timeout": 600,
	"method": "aes-256-cfb",
	"plugin": "v2ray-plugin",
	"plugin_opts": "tls;host=your.host;path=/yourpath"
}
```

**注意：** `local_address` 和 `local_port` 必须要是 **0.0.0.0** 和 **1080**。

Privoxy 的规则文件是 [gfw.action](./files/gfw.action)，可自行添加规则。

## 安装 ##

### 方法一 ###

```bash
git clone https://github.com/LJason77/docker-ss-v2ray.git
cd docker-ss-v2ray
docker build -t v2ray .
```

### 方法二 ###

```bash
docker pull ljason/docker-ss-v2ray
```

## 运行 ##

```bash
# 方法一安装
docker run -d --restart always --name v2ray -v /your/path/shadowsocks.json:/etc/shadowsocks.json --network host v2ray
# 方法二安装
docker run -d --restart always --name v2ray -v /your/path/shadowsocks.json:/etc/shadowsocks.json --network host ljason/docker-ss-v2ray
```
