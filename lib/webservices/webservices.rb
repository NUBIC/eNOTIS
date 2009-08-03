module WebServices
# TODO Need to implement some solid hierarchy of plugins
 
  Dir["lib/webservices/plugins/*.rb"].each {|file| require file}

  def  self.included(base)
    base.class_eval do 
      class << self
        alias_method :old_find, :find
        def find(*args)
           
           options = args.clone.extract_options!
           return old_find(*args) unless options[:span]
           case options[:span]
             when :local then return local_only(*args)
             when :foreign then return service_only(*args)
             when :global then return global_search(*args)
             else return raise("Unrecongnized value: #{options[:span]} for option :span")
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
            service_result = service_search(*args) unless !local_result.nil? and !local_result.stale?
          else
            service_result = service_search(*args) 
          end 
          case args.first
            when :first then return process_single(service_result,local_result)
            else        return   raise("Incompatible option #{args.first} with global search")
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
          return result unless !service_result.nil?
	  service_result.each do |val| 
            result << self.new(val)
          end
          return result
        end

        def get_plugins
          $plugins
        end     
        
        def set_plugins(plugins)
          $plugins = plugins
        end


        def service_search(*args)
          #This method searches all plugins, for a method name that
          #contains all the conditions provided e.g condition last_name
          #and last_name would match method find_by_fist_name_last_name
          options = args.clone.extract_options!
          conditions = convert_conditions_to_hash(options[:conditions])
          keys = conditions.keys
          get_plugins.each do |plugin|
	    meth = plugin.public_methods.detect{|method_name| keys.map{|x| method_name.include?(x.to_s.strip)}.uniq == [true]}
            if meth
              return plugin.send(meth,conditions.merge!(get_service_opts(options)))
            end
          end
          raise "No Method Found"
        end

        def convert_conditions_to_hash(conditions)
            #TODO this method needs to be cleaned
            #This method is used to convert the conditions
            #provided into a hash that is passed to webservies
            result={}
            if conditions.instance_of?(Hash)
              return conditions
	    elsif conditions.instance_of?(String)
              conditions.split("and").each do |condition|
	        result[condition.strip.split("=")[0].strip.to_sym] = condition.strip.split("=")[1].strip.gsub( /\A'/m, "" ).gsub( /'\Z/m, "" )
	      end
            elsif conditions.instance_of?(Array)
              conditions.first.split("and").each do |condition|
	        result[condition.strip.split("=")[0].strip.to_sym] = condition.strip.split("=")[1].strip.gsub( /\A'/m, "" ).gsub( /'\Z/m, "" )
	      end
            end
            return result
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


