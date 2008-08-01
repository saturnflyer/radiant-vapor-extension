class Admin::FlowMetersController < ApplicationController
  def index
    @flow_meters = FlowMeter.find(:all)
    @flow_meter = FlowMeter.new
  end
  
  def create
    @flow_meter = FlowMeter.create!(params[:flow_meter])
    redirect_to admin_flow_meters_url
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "oops"
    redirect_to admin_flow_meters_url
  end
  
  def destroy
    @flow_meter = FlowMeter.find(params[:id])
    @flow_meter.destroy
    redirect_to admin_flow_meters_url
  end
end
