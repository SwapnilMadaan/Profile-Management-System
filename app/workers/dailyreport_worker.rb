class DailyreportWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :report_queue, :unique => :all
	def perform()
		no_of_user_created_yesterday = User.where("Date(created_at) = ?" , Date.yesterday).count
  	    puts "#{no_of_user_created_yesterday}"
  	    file = File.open("daily_user_report.txt", "w")
  	    file.puts "Number of Users Created on #{Date.yesterday} : #{no_of_user_created_yesterday}"
  	    file.close
    end
end

Sidekiq::Cron::Job.create(name: 'Generate Report EveryDay', cron: '* /1 * * * *', class: 'DailyreportWorker')

