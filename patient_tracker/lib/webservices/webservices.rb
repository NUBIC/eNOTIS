module WebServices
# Need to implement some solid hierarchy of plugins
 
  def  self.included(base)
    base.extend(ClassMethods)
  end


  module ClassMethods
    Dir["lib/webservices/plugins/*.rb"].each {|file| require file}
    $plugins =[]
      Dir.new("lib/webservices/plugins").entries.each do |file| 
        if file[".rb"]
           mod = Kernel.const_get(file.to_s.gsub(".rb",""))
           $plugins <<  mod 
        end
      end

     def find(*args)
        if super.nil? or (super.class == Array and super.size == 0)
	  result = service_find(*args)
          if result
             return result
          end
        end
       return super
     end

    def service_find(*args)
      if args.size > 1
	options = args[1]
        search_scope = args[0]
        conditions =  options[:conditions]
      end
      if conditions.class == Hash
          conditions.each do |key,value|
            get_plugins.each do |plugin| 
              meth = plugin.public_methods.detect{|method_name| method_name[key.to_s]}
              if meth
    	        result = plugin.send(meth,value)
	        if result
		  return process_result(result)
                end
              end
            end  
          end
      end      
    end


    def process_result(result)
        if result.class == Hash
	  return self.new(result)	
        elsif result.class == Array
          new_result=[]
	  result.each do |entity|
    	    new_result << entity
          end
          return result
        else
          return nil
        end      
    end

    def set_plugins(plugins)
      $plugin = plugins
    end

    def get_plugins
       return $plugins
    end


  end
 
end


