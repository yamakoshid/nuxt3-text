
# MEMO

## ホストのユーザーとコンテナのユーザーをそろえる工夫

- https://qiita.com/yitakura731/items/36a2ba117ccbc8792aa7

あまり見ていないが、もっとうまくできそうな気がする。


## 公式ページ

https://www.docker.com/ja-jp/blog/understanding-the-docker-user-instruction/

## 必要なこと

- /home/<username>を作成する
  - VSCodeのサーバーをインストールするために必要
  - rootにならないと難しいか。
- <username>のUIDがhostと一致すること
  - /etc/passwd, /etc/groupを一致させておけばOK
- UIDは人それぞれ、usernameも人それぞれになる。
  - A. usernameを一つに固定。UIDをかえる(/etc/passwdをよまない?)
  - B. username, UIDをそのまま(/etc/passwdを読む)

- ~~現時点のDockerfileだと、ライブラリ系がrootでしか使えない。~~
  - aptでインストール権限を持っているのがrootだけ。
  - `root`で初めにaptでインストールしたら、多分一般ユーザーも使用できる。


- ubuntuイメージには、デフォルト`ubuntu`ユーザが、`UID: 1000`で存在している。

## Ubuntuコンテナでルートになる

ubuntuコンテナには、セキュリティ上の理由から、`sudo`は
インストールされていない。

`docker container`コマンド実行時に、`-u root`とすれば、
`root`でコマンドを実行できる。

- [How to send a password to `sudo` from a Dockerfile(Stack overflow)](https://stackoverflow.com/questions/44630072/how-to-send-a-password-to-sudo-from-a-dockerfile)

例: 

```
docker compose exec -u root dev /bin/bash
```

## Docker composeでコンテナをすぐ停止する方法について

docker compose stopなどを実行すると、SIGTERMがコンテナの`PID 1`に対して発行される。
そのため、`PID 1`のプロセスに、シグナルの処理を組み込めばよい。

アプリケーションにシグナルハンドラを実装する方法もある。

bashスクリプトだと、以下でできるらしい。

- DockerのFAQ, docker composeでコンテナすぐ停止できない件についての記事
  - [Why do my services take 10 seconds to recreate or stop?](https://docs.docker.com/compose/support-and-feedback/faq/#why-do-my-services-take-10-seconds-to-recreate-or-stop)
    - [Trapping signals in Docker containers](https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86)
  
      - bashの場合、次のようなシグナルハンドラを定義したスクリプトを用意するとよいらしい。
    
        The new entrypoint is a bash-script program.sh that orchestrates signal processing:
        ```
        #!/usr/bin/env bash
        set -x
  
        pid=0
  
        # SIGUSR1-handler
        my_handler() {
          echo "my_handler"
        }
  
        # SIGTERM-handler
        term_handler() {
          if [ $pid -ne 0 ]; then
            kill -SIGTERM "$pid"
            wait "$pid"
          fi
          exit 143; # 128 + 15 -- SIGTERM
        }
  
        # setup handlers
        # on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
        trap 'kill ${!}; my_handler' SIGUSR1
        trap 'kill ${!}; term_handler' SIGTERM
  
        # run application
        node program &
        pid="$!"
  
        # wait forever
        while true
        do
          tail -f /dev/null & wait ${!}
        done
        ```

## Dockerでディスク解放

- https://qiita.com/manrikitada/items/501a234d7fc30018445c

このあたりが必要かも。
- docker builder prune
- docker image prune

### 未検証のメモ書き

- gosuとか使えば、コンテナすぐ停止できるようにできたりする?
  - https://docs.docker.jp/v1.11/engine/reference/builder.html
