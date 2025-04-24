# ローカルビルド
## docker / devcontainer 環境を構築する

1. zmkをクローンした箇所に本レポジトリをクローンする
   
```
$ ls -F
zmk
$ git clone https://github.com/hatanoh/n40a8c-zmk-config.git
```

2. https://zmk.dev/docs/development/local-toolchain/setup/container?container=cli に従って環境を構築する。
   
   zmk-modulesは空のディレクトリを用意する。zmk-configは本レポジトリにシンボリックリンクを張る。

## zmk-configの設定

## ファームウェアのビルド
1. zmk-configディレクトリに移動する。

2. make する
   
```
$ make clean build
```
  
  XIAO RP2040用をビルドしたい場合は以下の通り
```
$ make clean build BOARD=seeeduino_xiao_rp2040
```

3. firmwareの確認

   ビルドしたfirmwareはfirmwareディレクトリにコピーされる
```
$ ls firmware/
n40a8c-seeeduino_xiao_ble-zmk.uf2  n40a8c-seeeduino_xiao_rp2040-zmk.uf2
```
