module Authentication
  module ByNetid
    # Stuff directives into including module
    def self.included(recipient)
      # recipient.extend(ModelClassMethods)
      recipient.class_eval do
        include ModelInstanceMethods
      end
    end #included directives

    # # Class Methods
    # module ModelClassMethods
    # end # class methods

    # Instance Methods
    module ModelInstanceMethods    
      def authenticated?(password)
        require 'ldap'
        ldap = LDAP::SSLConn.new("registry.northwestern.edu", 636)
        ldap.bind("uid=#{netid},ou=people,dc=northwestern,dc=edu", password)
        return (ldap.bound? ? true : false)
      rescue LDAP::ResultError
        return false
      ensure
        ldap.unbind unless ldap.nil?
        ldap = nil
      end
    end # instance methods
  end
end
