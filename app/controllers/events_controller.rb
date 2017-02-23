#require './icalendar/calendar'

class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def fill
    @event = current_user.events.find(params[:id])
    FindSitterJob.perform_later(@event)
    redirect_to :back
  end

  def index
    @events = current_user.events.order(starts_at: :desc)
  end

  def show
    @event = current_user.events.find(params[:id])
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to events_path
    else
      flash.now[:errors] = @event.errors.full_messages
      render :new
    end
  end

  def to_ics
    e = Icalendar::Event.new
    e.dtstart = self.starts_at.strftime("%Y%m%dT%H%M%S")
    e.dtend = self.ends_at.strftime("%Y%m%dT%H%M%S")
    e.summary = "test name"
    e.description = self.summary
    #event.location = 'Here !'
    e.ip_class = "PUBLIC"
    #event.created = self.created_at
    #event.last_modified = self.updated_at
    e.uid = e.url = "http://localhost:3000/events/#{self.key}"
    #event.add_comment("AF83 - Shake your digital, we do WowWare")
    e
  end

  def export_ics
    cal = Icalendar::Calendar.new
    @events = Event.all
    @events.each do |event|
      cal.add_event(@to_ics)
    end
    cal.publish
    respond_to do |format|
      format.ics { render body: cal.to_ics, mime_type: Mime::Type.lookup("text/calendar")  }
    end
    #render :text => cal.to_ical
  end

  def update
    @event = current_user.events.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path
    else
      flash.now[:errors] = @event.errors.full_messages
      render :edit
    end
  end

  private

  def event_params
    params
      .require(:event)
      .permit(:name, :food_included, :starts_at, :ends_at, :key, :flat_rate)
  end
end
