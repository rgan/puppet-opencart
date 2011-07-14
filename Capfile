set :user, "root"
task :deploy
  role :app, ‘development’
  run 'puppet agent --no-daemonize --onetime --server puppet --verbose'
end