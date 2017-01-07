module InfluxDB
  module Rails
    module Middleware

      prepend HijackRescueActionEverywhere
      
      module HijackRescueActionEverywhere
        # def self.included(base)
        #   base.send(:alias_method_chain, :rescue_action_in_public, :influxdb)
        #   base.send(:alias_method_chain, :rescue_action_locally, :influxdb)
        # end

        private
        def rescue_action_in_public(e)
          handle_exception(e)
          super(e)
        end

        def rescue_action_locally(e)
          handle_exception(e)
          super(e)
        end

        def handle_exception(e)
          request_data = influxdb_request_data || {}

          unless InfluxDB::Rails.configuration.ignore_user_agent?(request_data[:user_agent])
            InfluxDB::Rails.report_exception_unless_ignorable(e, request_data)
          end
        end
      end
    end
  end
end

