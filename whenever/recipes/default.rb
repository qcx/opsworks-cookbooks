Chef::Log.info("[Start] Updating Cron by Whenever")

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  bash "update-crontab-#{application}" do
    layers = node[:opsworks][:instance][:layers]

    cwd "#{deploy[:deploy_to]}/current"
    user 'deploy'

    Chef::Log.info("Updating cron ...")

    code "bundle exec whenever --set environment=#{deploy[:rails_env]} --update-crontab #{application} --roles #{layers.join(',')}"
    only_if "cd #{deploy[:deploy_to]}/current && bundle show whenever"
  end
end

Chef::Log.info("[End] Updating Cron by Whenever")