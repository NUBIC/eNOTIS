every 1.day do
  rake 'subjects:empi_upload', :output => '/var/www/apps/enotis/shared/log/export_cron.log'
end

every :saturday, :at => '10pm' do
  rake 'importer:full_mutha_trucking_update', :output => '/var/www/apps/enotis/shared/log/import_cron.log'
end

every :weekday, :at => '3am' do
  rake 'importer:priority_update', :output => '/var/www/apps/enotis/shared/log/import_cron.log'
end