# ベースイメージとしてRustを使用
FROM rust:latest

# 作業ディレクトリを設定
WORKDIR /usr/src

# ワークスペースの設定をコピー
COPY Cargo.toml ./

# 必要なCargo.tomlファイルと依存関係をコピー
COPY crates/typst-layout/Cargo.toml crates/typst-layout/

# ソースコードをコピー（stackとalignフォルダのみ）
COPY crates/typst-layout/src/stack.rs crates/typst-layout/src/
COPY crates/typst-layout/src/align/align.rs crates/typst-layout/src/align/
COPY crates/typst-layout/src/align/mod.rs crates/typst-layout/src/align/
COPY crates/typst-layout/src/main.rs crates/typst-layout/src/

# 依存関係を解決
RUN cargo build --release

# シェルを起動 
CMD ["sh"]
