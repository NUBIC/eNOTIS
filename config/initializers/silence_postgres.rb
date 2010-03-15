module ActiveRecord::ConnectionAdapters
  class PostgreSQLAdapter < AbstractAdapter
    def client_min_messages=(level)
      @logger.silence do
        execute("SET client_min_messages TO '#{level}'")
      end
    end
  end
end
