job_type :enotis_default, "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.day do
  enotis_default 'subjects:empi_upload', :output => '/var/www/apps/enotis/shared/log/export_cron.log'
end

every :saturday, :at => '10pm' do
  enotis_default 'importer:full_mutha_trucking_update', :output => '/var/www/apps/enotis/shared/log/import_cron.log'
end

every :weekday, :at => '3am' do
  enotis_default 'importer:priority_update', :output => '/var/www/apps/enotis/shared/log/import_cron.log'
end