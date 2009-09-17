Dir[File.dirname(__FILE__) + "/plugins/*.rb"].each {|file| require file}
module WebServices

  def  self.included(base)
    base.class_eval do 
      class << self
        cattr_accessor :plugins
        alias_method :old_find, :find
        def find(*args)
           
           options = args.clone.extract_options!
           return old_find(*args) unless options[:span]
           case options[:span]
             when :local then return local_only(*args)
             when :foreign then return service_only(*args)
             when :global then return global_search(*args)
             else raise DataServiceError.new("Unrecongnized value: #{options[:span]} for option :span")
           end
        end

        private

        def local_only(*args)
           #This only calls the local db
           #technically, should never be used
           old_find(*sanitize_option(*args))
        end

        
        def service_only(*args)
          #this method only calls the webservice
          service_result = service_search(*args)
          case args.first
            when :first then return process_single(service_result,nil)
            when :all   then return process_multiple(service_result,nil)
          end
                
        end

        
        def global_search(*args)
          #This method searches both the local db and webservice
          #only hitting the latter if the former is either non existant
          # or outdated
          service_result = nil
          local_result = old_find(*sanitize_option(*args))
          if args.first == :first
            service_result = service_search(*args) if local_result.nil? or local_result.stale?
          else
            service_result = service_search(*args) 
          end 
          case args.first
            when :first then return process_single(service_result,local_result)
            else        raise DataServiceError.new("Incompatible option #{args.first} with global search")
          end
        end

        def process_single(service_result,local_result)
          if service_result and service_result.first
            service_result.first[:synced_at]=Time.now
	    return local_result.sync!(service_result.first) unless local_result.nil?
            return self.new(service_result.first)
          else 
            return local_result 
          end
        end

        def process_multiple(service_result,local_result)
          # this method simply returns the list of new objects 
          # created using the search results, no reconciliation is done
          result=[]
          return result if service_result.nil?
	  service_result.each do |val| 
            result << self.new(val)
          end
          return result
        end
        def service_search(*args)
          #This method searches all plugins, for a method name that
          #contains all the conditions provided e.g condition last_name
          #and last_name would match method find_by_fist_name_last_name
          options = args.clone.extract_options!
          conditions = options[:conditions]
          raise DataServiceError.new("Webservices Only Supports Hash Conditions at this time") unless conditions.instance_of?(Hash)
          keys = conditions.keys
          begin
            self.plugins.each do |plugin|
	      meth = plugin.public_methods.detect{|method_name| keys.map{|x| method_name.include?(x.to_s.strip)}.uniq == [true]}
              if meth
                return plugin.send(meth,conditions.merge!(get_service_opts(options)))
              end
            end
          rescue DataServiceError
              #supress data service errors
              return nil
          end
          raise DataServiceError.new("No Method Found")

        end

        def get_service_opts(options)
          #This method adds additional parameters to the conditions hash that are not part of the query
          #Right now this is only being used for net-id
          options[:service_opts] || {}
        end

        def sanitize_option(*args)
          #this method removes all webservice specific options 
          #before passing args to the old_find
          options = args.clone.extract_options!.clone
          options.delete(:span)
          options.delete(:service_opts)
          return args.first,options
        end

      end
    end
  end
end


