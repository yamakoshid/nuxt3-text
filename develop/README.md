
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



## gosuとかみてたら、もしかして、コンテナすぐ停止できるようにできたりする?

https://docs.docker.jp/v1.11/engine/reference/builder.html