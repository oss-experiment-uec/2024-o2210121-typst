# Artifact Description

## 概要：alignによる簡易なスタックの配置の決定(の前段階)

**題材選び2回ともミスって時間切れで爆散したので、これのレビューは多分やらない方がいいと思います。**

こちらのtypstの改変を行おうとした。

```
https://github.com/typst/typst
```

これは、容易に利用できる軽いlatexのようなOSSです。

そして、今回はこのissueを実装しようとした。

```
https://github.com/typst/typst/issues/5633
```

私は、stackを右、真ん中、左で簡単に指定できるようなalignのパラメータを考えた。

時間的な都合で、stack.rsとalignフォルダの増設、テスト用のmain.rsを生成し、main.rsからAlignを最低限呼び出せるようにした。


(言い訳：でもalignに書き変えなければいけない範囲があまりにも広すぎて(おそらく実装コード全範囲)時間切れしたので、そもそもpdfとかの画像として出力するまでに至ることが出来なかった。なんなら、第7回まで初回で決めたコードをいじいじして全然テスト環境すらできなくて爆発させてしまって、こっちに切り替えたらまた爆発しましたごめんなさい。)

## クイックスタート

以下，記述事項の説明．
dockerを起動した状態で、以下を行う。

```
docker image pull reiyaohnishi/typst
docker run -it --rm reiyaohnishi/typst
```

```
cargo run --release
```

## 評価手順
stack.rsのalignとmain.rsへ情報のやり取りができる。

```
cargo run --release
```

を実行すると

```
    Finished `release` profile [optimized] target(s) in 0.02s
     Running `target/release/typst-layout`
Hello, Typst Layout!
Left aligned
Center aligned
Right aligned
```

が出力される．

これは、main.rsが実行され、stack.rsのalignが呼び出された結果、このように出力されている。

## 制限と展望


とりあえず、すべての範囲でalignが認識できるように改変すべきである。
ただ、パラメータが増えるという性質から、あまりにも改変範囲が膨大なので、align実装のためだけに改変するべきかどうかは一考する価値があると思われる。私だったら時間があったとしても絶対に諦める。

また、画像によるチェックをするまでに至らなかったが、もしalignの全体の改変ができたとして、alignの中身(ちゃんと機能として左寄せにするなど)ができるようにしなければいけない。


## 更なる使い方（オプション）

比率表記で実装できるのであれば、それもありだろうと思われる。(横2:3の場所を中心とするなど)
