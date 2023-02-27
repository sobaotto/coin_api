# 環境構築

> 手順
```
docker-compose build
docker-compose up -d
docker-compose run web rails db:create
```

> DBアクセス
```
docker-compose exec db mysql -u root -p coin_development
```

# 設計
## API
**※詳細は`openapi.yml`を参照**

| メソッド |  エンドポイント  |  機能  |
|-|-|-|
| GET | /me | ユーザー情報 |
| POST | /login | ログイン |
| DELETE | /logout | ログアウト |
| GET | /users/{id} | ユーザー情報 |
| POST | /users | ユーザー登録 |
| GET | /users/{id}/balance | 残高確認 |
| PUT | /users/{id}/balance | 残高更新 |
| POST | /users/{id}/transfer | 送金 |
| GET | /users/{id}/history | 取引履歴 |


## テーブル
**※型や制約などの詳細は`db/schema.rb`を参照**

> Users

|  カラム  |  内容  |
|-|-|
| id | ID |
| name | ユーザー名 |
| email | メールアドレス |
| password_digest | パスワード |
| balance | 口座残高 |
| created_at | 作成日時 |
| updated_at | 更新日時 |
> Transactions

|  カラム  |  内容  |
|-|-|
| id | ID |
| user_id | ユーザーID |
| type | 取引種別 |
| amount | 取引金額 |
| created_at | 作成日時 |
| updated_at | 更新日時 |
