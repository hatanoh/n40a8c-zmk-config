# ローカルビルド
## docker / devcontainer 環境を構築する

1. https://zmk.dev/docs/development/local-toolchain/setup/container?container=cli に従って環境を構築する。
   
   zmk-modules/zmk-configは空のディレクトリを用意する。

## zmk-configの設定

1. zmkをクローンした箇所に本レポジトリをクローンする
   
```
$ ls -F
zmk
$ git clone https://github.com/hatanoh/n40a8c-zmk-config.git
```

2. クローンしたディレクトリに移動する
   
```
$ cd n40a8c-zmk-config
```

3. settings.mkを作成する
   
   settings.mkに構築したdockerのコンテナ名を設定する
```
$ docker ps
CONTAINER ID   IMAGE                                                                      COMMAND                  CREATED        STATUS        PORTS     NAMES
************   vsc-zmk-****************************************************************   "/bin/sh -c 'echo Co…"   ** hours ago   Up ** hours             <container_name>
$ vi settings.mk
container_name = <container_name>
```

4. dockerコンテナをリスタートする

   zmk-configをシンボリックリンクしコンテナを起動する。
```
$ rmdir zmk-config
$ make restart
```


## ファームウェアのビルド
1. make する
   
```
$ make clean build
```
  
  XIAO RP2040用をビルドしたい場合は以下の通り
```
$ make clean build BOARD=seeeduino_xiao_rp2040
```

2. firmwareの確認

   ビルドしたfirmwareはfirmwareディレクトリにコピーされる
```
$ ls firmware/
n40a8c-seeeduino_xiao_ble-zmk.uf2  n40a8c-seeeduino_xiao_rp2040-zmk.uf2
```
