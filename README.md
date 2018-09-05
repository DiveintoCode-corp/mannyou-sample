# 万葉様研修課題 by mentor shibata

このカリキュラムは株式会社万葉様より許諾を経て進めている研修課題のカリキュラムになります。

# 開発環境

## 言語・ミドルウェアなど

- ruby 2.5.1p57
- Rails 5.2.1
- psql (PostgreSQL) 9.6.3

# セットアップ

- git clone git@github.com:shibatadaiki/manyousama-kennsyuu.git
- cd manyousama-kennsyuu
- bundle install --path vendor/bundle
- rails db:create db:migrate
- rails s