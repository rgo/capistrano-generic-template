##
# Application parameters
#
set :application, ""
set :repository,  ""
set :keep_releases, 2
set :rails_env, "production"

##
# SSH parameters
#
set :user, ""
ssh_options[:config] = false
set :use_sudo, false

##
# Deployment strategy parameters
#
set(:scm_username) { Capistrano::CLI.ui.ask("Type is your svn username: ") }
set(:scm_password){ Capistrano::CLI.password_prompt("Type your svn password for user #{scm_username}: ") }
set :deploy_via, :export
set :deploy_to, "/home/#{user}/ASPgems"

##
# Database access data variables
#
set :database_server, ""
set :database_username, ""
set(:database_password){ Capistrano::CLI.password_prompt("Give me a database password for user #{database_username}: ") }
set :database_name_dev, "aspgems_#{application}_web_development"
set :database_name_test, "aspgems_#{application}_web_test"
set :database_name_prd, "aspgems_#{application}_web_production"

##
# Hosts variables
# 
role :app, ""
role :web, ""
role :db,  "", :primary => true

##
# Config_files & asset directories
#
set :config_files_array, %w(database.yml initializers/mailer.rb)
set :assets_array, %w(public/assets assets)

##
# Mailer variables
#
set :mailer_domain, ""


##
# Load common tasks
#
load 'config/deploy/common_tasks'


##
# Load extra tasks:
#		- deploy:fiveruns
#		- deploy:ultrasphinx:index
#		- deploy:ultrasphinx:configure
#
#load 'config/deploy/extra_tasks'
