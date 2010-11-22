# monkey patch for database_cleaner's truncation: connection with oracle xe ubuntu vm - yoon
require 'database_cleaner/active_record/truncation'
module DatabaseCleaner::ActiveRecord
  class Truncation
    private
    def connection
       # this line forces the connection to be cached. when it isn't, I get a lot of errors:
       #   TNS:listener could not find available handler with matching protocol stack
       # http://forums.oracle.com/forums/thread.jspa?messageID=3873333
       # -yoon
       @connection ||= connection_klass.connection
    end
  end
end
