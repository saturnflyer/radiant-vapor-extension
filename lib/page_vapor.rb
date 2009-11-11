module PageVapor
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end
  module InstanceMethods
    def flow_meter
      FlowMeter.find_for_page(self)
    end
  end
end