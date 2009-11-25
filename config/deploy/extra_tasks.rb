namespace :deploy do

  require 'erb'

  "Installing fiveruns on the app"
  task :fiveruns, :except => { :no_release => true }  do
    run "fiveruns_manage #{current_path}"
    run "chmod 777 #{shared_path}/tmp"
  end

  namespace :ultrasphinx do

    desc 'configure and index ultrasphinx'
    task :index, :roles => :db do
      rake = fetch(:rake, 'rake')
      rails_env = fetch(:rails_env, 'production')
      run "cd #{deploy_to}/current; #{rake} ultrasphinx:index RAILS_ENV=#{rails_env}"
      run "cd #{deploy_to}/current; #{rake} ultrasphinx:daemon:restart RAILS_ENV=#{rails_env}"
    end

    desc 'configure ultrasphinx'
    task :configure  do
      # Create ultrasphinx paths
      run "rm -rf #{current_path}/config/ultrasphinx"
      run "ln -s #{shared_path}/config/ultrasphinx #{current_path}/config"

      # Generate #{stages}.base files
      %w(default development production).each do |file|
        template = File.read(File.join(File.dirname(__FILE__), "deploy/templates", "ultrasphinx_#{file}.base"))
        result = ERB.new(template).result(binding)

        run "mkdir -p #{shared_path}/config/ultrasphinx"
        put result, "#{shared_path}/config/ultrasphinx/#{file}.base"
      end

      # Generate #{stages}.conf files
      %w(development production).each do |file|
        template = File.read(File.join(File.dirname(__FILE__), "deploy/templates", "ultrasphinx_#{file}.conf"))
        result = ERB.new(template).result(binding)

        run "mkdir -p #{shared_path}/config/ultrasphinx"
        put result, "#{shared_path}/config/ultrasphinx/#{file}.conf"
      end

      # Create a path where store indexes
      run "mkdir -p #{shared_path}/sphinx"

      # Execute rake task
      rake = fetch(:rake, 'rake')
      rails_env = fetch(:rails_env, 'production')
      run "cd #{deploy_to}/current; #{rake} ultrasphinx:configure RAILS_ENV=#{rails_env}"

    end

  end
end
