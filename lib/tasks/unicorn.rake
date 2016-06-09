namespace :load do
  task :defaults do
    set :unicorn_pid, -> { File.join("#{current_path}/shared", "pids", "unicorn.pid") }
    set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
    set :unicorn_roles, -> { [:web, :app] }
    set :unicorn_options, -> { "" }
    set :unicorn_rack_env, -> { fetch(:rails_env) }
    set :unicorn_restart_sleep_time, 3
    set :unicorn_workers, 5
    set :unicorn_timeout, 30
    set :listen_ip, '0.0.0.0'
    set :listen_port, 3003
  end
end

namespace :unicorn do
  
  desc "Start Unicorn"
  task :start do
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        if test("[ -e #{fetch(:unicorn_pid)} ] && kill -0 #{pid}")
          info "unicorn is running..."
        else
          with rails_env: fetch(:rails_env) do
            execute :bundle, "exec unicorn", "-c", fetch(:unicorn_config_path), "-E", fetch(:unicorn_rack_env), "-D", fetch(:unicorn_options), "-p", listen_port
          end
        end
      end
    end
  end

  desc "Stop Unicorn (QUIT)"
  task :stop do
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        if test("[ -e #{fetch(:unicorn_pid)} ]")
          if test("kill -0 #{pid}")
            info "stopping unicorn..."
            execute :kill, "-s QUIT", pid
          else
            info "cleaning up dead unicorn pid..."
            execute :rm, fetch(:unicorn_pid)
          end
        else
          info "unicorn is not running..."
        end
      end
    end
  end

  desc "Reload Unicorn (HUP); use this when preload_app: false"
  task :reload do
    invoke "unicorn:start"
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        info "reloading..."
        execute :kill, "-s HUP", pid
      end
    end
  end

  desc "Restart Unicorn (USR2); use this when preload_app: true"
  task :restart do
    invoke "unicorn:start"
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        info "unicorn restarting..."
        execute :kill, "-s USR2", pid
      end
    end
  end

  desc "Duplicate Unicorn; alias of unicorn:restart"
  task :duplicate do
    invoke "unicorn:restart"
  end

  desc "Legacy Restart (USR2 + QUIT); use this when preload_app: true and oldbin pid needs cleanup"
  task :legacy_restart do
    invoke "unicorn:restart"
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        execute :sleep, fetch(:unicorn_restart_sleep_time)
        if test("[ -e #{fetch(:unicorn_pid)}.oldbin ]")
          execute :kill, "-s QUIT", pid_oldbin
        end
      end
    end
  end

  desc "Add a worker (TTIN)"
  task :add_worker do
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        info "adding worker"
        execute :kill, "-s TTIN", pid
      end
    end
  end

  desc "Remove a worker (TTOU)"
  task :remove_worker do
    on roles(fetch(:unicorn_roles)) do
      within current_path do
        info "removing worker"
        execute :kill, "-s TTOU", pid
      end
    end
  end

  desc "Creates the unicorn.yml configuration file in shared path."
  task :setup do
    #location = 'lib/capistrano/templates/unicorn.rb.erb'
    #template = File.file?(location) ? File.read(location) : raise("template file '#{location}' not found!")

    #config = ERB.new(template)

    on roles(fetch(:unicorn_roles)) do
      #execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{current_path}/shared/pids"
      execute "mkdir -p #{current_path}/shared/log"
      execute "mkdir -p #{current_path}/shared/sockets"
      #upload! StringIO.new(config.result), "#{shared_path}/config/unicorn.rb"
      # config.result(binding)
    end
  end
end

def pid
  "`cat #{fetch(:unicorn_pid)}`"
end

def pid_oldbin
  "`cat #{fetch(:unicorn_pid)}.oldbin`"
end

def unicorn_workers
  "#{fetch(:unicorn_workers)}"
end

def unicorn_timeout
  "#{fetch(:unicorn_timeout)}"
end

def listen_ip
  "#{fetch(:listen_ip)}"
end

def listen_port
  "#{fetch(:listen_port)}"
end