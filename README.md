## 設計
TCAを採用している。<br>
ただし、全てのViewに対してStoreを設定しない。表示するだけの画面であれば値の受け渡しのみを行う。

## 構成
トップページに関連する画面の状態とアクションは1つのStoreで管理し、サブビューに対し必要な状態とアクションを抽出して受け渡す。<br>
トップページに関連しない画面の状態とアクションはサブビューから派生する画面で新たに作成したStoreのインスタンスを渡す。

- App
  - アプリのコアに関する機能
- View
  - 各機能のUI
- Model
  - 各機能のAPIモデル
- DataFlow
  - 各機能のデータの管理、変更処理
- Util
  - その他の機能


## データフロー

基本的には公式通り。<br>
状態を管理するStateとそのステートの更新や副作用の発生を行うReducerがある。<br>
ViewからActionを発行するとReducerが検知し、値の更新やEnvirmentからAPIリクエストを発行する。<br>
各画面では状態とActionを内包したStoreを購読し、状態に変更があれば、購読している画面の再描画が行われる。<br>
API等のやり取りはEnviroment経由で行う。Storeの生成時に必要な依存を注入する。

<img width="646" alt="スクリーンショット 2022-08-17 11 00 40" src="https://user-images.githubusercontent.com/65114797/185018045-51868112-d963-457c-b502-90738513df53.png">

<br>
<br>

**例 アプリ起動から募集一覧の取得**

1. アプリ起動後、トップ画面を呼び出す際にStoreのインスタンスを渡す。

<img width="395" alt="スクリーンショット 2022-08-17 2 55 29" src="https://user-images.githubusercontent.com/65114797/184946712-7f2f921e-3597-42aa-a740-3f86fffc52cc.png">


2. タブページャーの中の募集一覧画面を呼び出す際にAppStoreから募集一覧画面に必要な状態とアクションを元にStoreを作成し、インスタンスを渡す。

<img width="395" alt="スクリーンショット 2022-08-17 2 54 46" src="https://user-images.githubusercontent.com/65114797/184946587-7f3b7ea0-2070-4bc0-9d2b-5dcc38304cef.png">


3. 募集一覧画面の起動時に募集一覧を取得するためのアクションを発行する。

<img width="542" alt="スクリーンショット 2022-08-17 3 16 37" src="https://user-images.githubusercontent.com/65114797/184950415-0f61c8b1-aeac-40f3-989d-943392c96ae1.png">

4. 発行されたアクションをReducerが検知し、Storeが依存しているRecruitmentClientからAPIリクエストの発行を行う。

<img width="551" alt="スクリーンショット 2022-08-17 2 57 38" src="https://user-images.githubusercontent.com/65114797/184947132-20d78ae6-4cb5-4680-ad07-2f3a0471cfed.png">

5. APIRequestのrequest関数内でタスクを実行し、レスポンスを内包したパブリッシャーを返却する。

<img width="703" alt="スクリーンショット 2022-08-17 2 34 43" src="https://user-images.githubusercontent.com/65114797/184947831-02c9d44b-aed2-4959-8404-4736bb592d82.png">

6. パブリッシャーが返却された後に新たなアクションの発行を行い、通信のキャンセルを行う。

<img width="556" alt="スクリーンショット 2022-08-17 3 19 01" src="https://user-images.githubusercontent.com/65114797/184950854-db480026-1816-43cf-aace-4a0aec0ce561.png">


7. 新たに発行されたアクションで前のアクションから受け取ったレスポンスを利用し、データの更新を行う。

<img width="609" alt="スクリーンショット 2022-08-17 3 11 36" src="https://user-images.githubusercontent.com/65114797/184949596-9f02c310-b726-413d-8c93-b4013a677a04.png">

8. 状態を購読している募集一覧画面が再描画される。エラーが発生している場合はアラートの表示を行う。

<img width="490" alt="スクリーンショット 2022-08-17 3 14 08" src="https://user-images.githubusercontent.com/65114797/184949962-83a85f2a-b47c-4660-95d1-d9c040dfbdb8.png">

