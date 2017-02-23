desc "Send Reminders"
task :send_reminders => :environment do
  events = Event
    .where(reminded: false)
    .where('starts_at < ?', Date.current - 1.days)
  events.each do |event|
    EventReminderJob.perform_later(event.id)
  end
end
