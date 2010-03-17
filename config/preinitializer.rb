begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  raise RuntimeError, "You have not locked your bundle. Run `bundle lock`."
 
end
