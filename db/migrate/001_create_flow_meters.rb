class CreateFlowMeters < ActiveRecord::Migration
  def self.up
    create_table :flow_meters do |t|
      t.string :catch_url
      t.string :redirect_url
      t.string :status, :default => '307'

      t.timestamps
    end
  end

  def self.down
    drop_table :flow_meters
  end
end
