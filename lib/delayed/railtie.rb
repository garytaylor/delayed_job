require 'delayed_job'
require 'rails'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      if ActiveRecord::Base.connection.tables.include?('delayed_jobs')
        Delayed::Worker.guess_backend
      else
        puts "Warning: Delayed::Job not loaded due to missing table.  If you are not migrating, please add the delayed job migration to your application"
      end

      ActiveSupport.on_load(:action_mailer) do
        ActionMailer::Base.send(:extend, Delayed::DelayMail)
      end
    end

    rake_tasks do
      load 'delayed/tasks.rb'
    end
  end
end
