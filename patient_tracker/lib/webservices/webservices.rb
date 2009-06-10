module WebServices
# Need to implement some solid hierarchy of plugins
 
  Dir["lib/webservices/plugins/*.rb"].each {|file| require file}

  def web_attribute(attribute)
    #needs to be inplemented 
  end

  def  self.included(base)
    base.class_eval do 
      class << self
        alias_method :old_find, :find
        def find(*args)
           #local_args = args.clone   
           #options = local_args.extract_options!
           #unless
 	   case args.first
             when :first then  return local_first(*args)
             when :all   then  return old_find(*args)
             else 	       return old_find(*args)
           end

        end

        private

        def local_only(*args)
           old_find(*args)
        end

        
        def service_only(*args)
          #needs to be implementede
        end

        
        def local_first(*args)
          service_result = nil
          #assumption is only single returns use this method
          local_result = old_find(*args)
          service_result = service_search(*args) unless !local_result.nil? and local_result.current?
          return process_single(service_result,local_result)
        end

        def process_single(service_result,local_result)
          if service_result
	    return local_result.reconcile(service_result.first) unless !local_result
            return self.new(service_result.first) unless !service_result
          else local_result
            return local_result 
          end
        end

        def process_multiple(service_result,local_result)
           
        end

        def get_plugins
          $plugins
        end     
        
        def set_plugins(plugins)
          $plugins = plugins

        end

        def service_first(*args)     
          #tto be implemented   
	  #service_result = service_search(*args)
          #return old_find(*args) unless service_result
          #local_result = old_find(*args)
        end

        def service_search(*args)
          local_args = args.clone
          options = local_args.extract_options!
          conditions = options[:conditions]
          conditions.each do |key,value|
            get_plugins.each do |plugin| 
              meth = plugin.public_methods.detect{|method_name| method_name[key.to_s] and method_name["find"]}
              if meth
    	        return plugin.send(meth,value)
              end
            end  
          end      
        end

      end
    end
  end
end


