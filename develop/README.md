
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

- 現時点のDockerfileだと、ライブラリ系がrootでしか使えない。


## Docker composeでコンテナをすぐ停止する方法について

docker compose stopなどを実行すると、SIGTERMがコンテナの`PID 1`に対して発行される。
そのため、`PID 1`のプロセスに、シグナルの処理を組み込めばよい。

アプリケーションにシグナルハンドラを実装する方法もある。

bashスクリプトだと、以下でできるらしい。

- DockerのFAQのコンテナすぐ停止できない件
  - https://docs.docker.com/compose/support-and-feedback/faq/#:~:text=The%20docker%20compose%20stop%20command%20attempts%20to%20stop,shutting%20down%20when%20they%20receive%20the%20SIGTERM%20signal.
    - https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86
  
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



### gosuとか使えば、コンテナすぐ停止できるようにできたりする?

https://docs.docker.jp/v1.11/engine/reference/builder.html
