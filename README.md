# GitHub/GitLabでのAWS環境へのOIDCによる認証サンプル
このコードは、GitHubまたはGitLabから、AWS環境にOIDC認証による接続を行い、
ActionsTerraformなどによるCI実行を行うためのサンプル実装です。


## セットアップ手順
## 事前準備
実行環境として`AdministratorAccess`権限でマネージメントコンソール操作が可能なユーザを用意すること。

## GitHub CI環境のセットアップ
### GitHubのリポジトリ作成
- GitHubでリポジトリを作成します
- 作成したリポジトリのリポジトリ名を控えます(`ManagedeServiceCore/managed-service-terraform`など)

### OIDCプロバイダのサムプリント取得
OIDCプロバイダー設定のための事前情報取得として、OIDCプロバイダーのサムプリント(Thumbprint)を取得します。
サムプリントは、証明書の暗号化ハッシュです。

- GitHubまたはGitLabのOIDC
#### OIDC IdP設定情報取得先URLの指定
```shell
URL="https://token.actions.githubusercontent.com/.well-known/openid-configuration" #GitHubの場合
# URL="https://gitlab.com/.well-known/openid-configuration" #GitLabの場合

#確認
echo $URL
```
#### OIDC IdPの証明書取得

```shell
#ドメイン取得
FQDN=$(curl $URL 2>/dev/null | jq -r '.jwks_uri' | sed -E 's/^.*(http|https):\/\/([^/]+).*/\2/g')
echo $FQDN

#サーバー証明書の取得
 echo | openssl s_client -connect $FQDN:443 -servername $FQDN -showcerts | sed -ne '/BEGIN CERT/,/END CERT/p'
```
opensslコマンドを実行すると、次のような証明書が複数表示されます。 複数の証明書のうち表示される最後 (コマンド出力の最後) の証明書を特定します。

```
-----BEGIN CERTIFICATE-----
MIICiTCCAfICCQD6m7oRw0uXOjANBgkqhkiG9w0BAQUFADCBiDELMAkGA1UEBhMC
VVMxCzAJBgNVBAgTAldBMRAwDgYDVQQHEwdTZWF0dGxlMQ8wDQYDVQQKEwZBbWF6
<中略>
FFBjvSfpJIlJ00zbhNYS5f6GuoEDmFJl0ZxBHjJnyp378OD8uTs7fLvjx79LjSTb
NYiytVbZPQUQ5Yaxu2jXnimvw3rrszlaEXAMPLE=
-----END CERTIFICATE-----
```

証明書 (`-----BEGIN CERTIFICATE-----` および `-----END CERTIFICATE-----` 行を含む) をコピーして、テキストファイルに貼り付けます。次に、certificate.crt という名前でファイルを保存します。

```shell
cat > certificate.crt
最後の証明書を貼り付けて、最後にCTRL+Dで終了する

#ファイルの確認
cat certificate.crt
```
#### サムプリントの取得
証明書からサムプリントを取得します。`9999FD4D99BAB99FAADB99B9999999E3780AEA1`のような文字列が取得できれば成功です。
```shell
THUMBPRINT=$(openssl x509 -in certificate.crt -fingerprint -noout | sed -E 's/SHA1 Fingerprint=(.*)/\1/g' | sed -E 's/://g')

#取得したサムプリントの確認
echo $THUMBPRINT
```

#### サムプリント取得に関する参考情報
- [GitHub: About security hardening with OpenID Connect](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [GitLab: GitLab as OpenID Connect identity provider](https://docs.gitlab.com/ee/integration/openid_connect_provider.html)
- [AWS IAMユーザガイド: OpenID Connect ID プロバイダーのサムプリントの取得](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html)




### OIDCプロバイダー/IAMロール作成/S3バケット/DynamoDB作成









