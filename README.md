# ローカルビルド
## 環境を構築する

1. docker と devcontainer をインストールする
   
   https://docs.docker.com/engine/install/ や https://code.visualstudio.com/docs/devcontainers/devcontainer-cli を参照してインストールする

3. コンテナを構築する

```
$ make setup
```

   zmk-configは本レポジトリのディレクトリ、zmk-modulesは本レポジトリの下のmodulesがマウントされる。

   zmkは一つ上のディレクトリにcloneされる

```
+- zmk
+- n42a7c-zmk-config (zmk-config)
  +- boards
    +- shield
      +- n42a7c
  +- config
  +- firmware
  +- modules (zmk-modules)
  +- zephyr
```

## ファームウェアのビルド
1. makeする
```
$ make cleanall buildall
```

2. firmwareの確認

   ビルドしたfirmwareはfirmwareディレクトリにコピーされる
```
$ ls firmware/
n42a7c-seeeduino_xiao_ble-zmk.uf2  n42a7c-seeeduino_xiao_rp2040-zmk.uf2
```

## コンテナの削除
```
$ make remove
```
zmk環境以外には影響しないと思われるが実行する場合は必ずMakefileを確認してから実施すること。
