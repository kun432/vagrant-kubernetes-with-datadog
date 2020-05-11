# vagrant-kubernetes-with-datadog

vagrantで作ったkubernetes環境にdatadogでモニタリングを設定します。

Vagrantで以下の初期環境が構築されます。

- kubernetesクラスタ
  - master x 1
  - worker x 2
  - CNIはCalico

あとは手順に従ってdatadogの設定を行います。

## 必要なもの

- Vagrant

```
$ brew cask install vagrant virtualbox virtualbox-extension-pack
```

- datadogアカウント
  - アカウント作成後、14日間は試用期間として無料でフル機能にアクセスできます。
  - それ以降でも無料版アカウントあります。（ただしログやAPMなどの機能にはアクセスできません）

## 使い方

```
$ git clone https://github.com/kun432/vagrant-kubernetes-with-datadog.git
$ vagrant up
```
