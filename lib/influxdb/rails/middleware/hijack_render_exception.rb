module InfluxDB
  module Rails
    module Middleware
      module HijackRenderException
        def self.included(base)
          base.prepend HijackRenderException
        end

        def render_exception(env, e)
          controller = env["action_controller.instance"]
          request_data = controller.try(:influxdb_request_data) || {}
          unless InfluxDB::Rails.configuration.ignore_user_agent?(request_data[:user_agent])
            InfluxDB::Rails.report_exception_unless_ignorable(e, request_data)
          end
          super(env, e)
        end
      end
    end
  end
end

