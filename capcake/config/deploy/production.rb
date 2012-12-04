# production

role :app, *%w[
  172.17.82.8
]

set :port, 64
set :user, "capcake_deployer"
set(:password) do
    Capistrano::CLI.password_prompt "productionサーバのパスワードを入力してください: "
end
