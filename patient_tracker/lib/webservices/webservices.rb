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
           #return args
           options = args.clone.extract_options!
           return old_find(*args) unless options[:span]
           options2 = options.clone
           options2.delete(:span)
           case options[:span]
             when :local then return local_only(args.first,options2)
             when :foreign then return service_only(args.first,options2)
             when :global then return global_search(args.first,options2)
             else return raise "Unrecongnized value: #{options[:span]} for option :span"
           end
        end

        private

        def local_only(*args)
           old_find(*args)
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
          service_result = nil
          local_result = old_find(*args)
          if args.first == :first
            service_result = service_search(*args) unless !local_result.nil? and local_result.current?
          else
            service_result = service_search(*args) 
          end 
          case args.first
            when :first then return process_single(service_result,local_result)
            else        return   raise "Incompatible option #{args.first} with global search"
          end
        end

        def process_single(service_result,local_result)
          if service_result and service_result.first
            service_result.first[:last_reconciled]=Time.now
	    return local_result.reconcile(service_result.first) unless local_result.nil?
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
          local_args = args.clone
          options = local_args.extract_options!
          conditions = convert_conditions_to_hash(options[:conditions])
          keys = conditions.keys
            get_plugins.each do |plugin|
	      meth = plugin.public_methods.detect{|method_name| keys.map{|x| method_name.include?(x.to_s)}.uniq == [true]}
              if meth
                return plugin.send(meth,conditions)
              end
            end
         return nil     
        end

        def convert_conditions_to_hash(conditions)
            result={}
            if conditions.instance_of?(Hash)
              return conditions
	    elsif conditions.instance_of?(String)
              conditions.split("and").each do |condition|
	        result[condition.split("=")[0].to_sym] = condition.split("=")[1].gsub( /\A'/m, "" ).gsub( /'\Z/m, "" )
	      end
            elsif conditions.instance_of?(Array)
              conditions.first.split("and").each do |condition|
	        result[condition.split("=")[0].to_sym] = condition.split("=")[1].gsub( /\A'/m, "" ).gsub( /'\Z/m, "" )
	      end
            end
            return result
        end
      end
    end
  end
end


