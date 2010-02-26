require 'crypto-key'
class ExternalEventProcessor < ApplicationProcessor
  attr_accessor :priv_key,:pub_key
  subscribes_to :external_event
  
  @message=''
  def on_message(message)
    logger.debug "ExternalEventProcessor received: " + message
    @message = message
    params = decrypt(JSON(message))    
    normalized_params = normalize(params)
    logger.debug "ExternalEventProcessor received: " + normalized_params.to_s
    InvolvementEvent.add(normalized_params)
  end


  def on_error(err)
    if (err.kind_of?(StandardError))
      logger.error "ApplicationProcessor::on_error: #{err.class.name} rescued:\n" + \
      err.message + "\n" + \
      "\t" + err.backtrace.join("\n\t")
    else
      logger.error "ApplicationProcessor::on_error: #{err.class.name} raised: " + err.message
      raise err
    end
  end  



  private
  def decrypt(value)
    private_key = Crypto::Key.from_file("#{RAILS_ROOT}/lib/rsa_key")
    if value.is_a?Hash
      value.each_pair do |k,v|
          value[k] = decrypt(v)
      end
    elsif value.is_a?Array
      value.each do |val|
         decrypt(val)
      end
    else
      return private_key.decrypt(value.to_s)
    end
    return value
  end


  def normalize(params)
    params = symbolize(params)
    params[:involvement][:gender_type_id] = DictionaryTerm.gender_id(params[:involvement][:gender])
    params[:involvement].delete(:gender)
    params[:involvement][:ethnicity_type_id]  = DictionaryTerm.ethnicity_id(params[:involvement][:ethnicity])
    params[:involvement].delete(:ethnicity)
    new_events=[]
    params[:involvement_events].each do |val|
      val[:event_type_id] = DictionaryTerm.event_id(val[:type])
      val.delete(:type)
    end
    return params
  end
  #recursively symbolize the parameters
  def symbolize(params)
    if params.is_a?Hash
      params.symbolize_keys!
      params.each_pair do |k1,v1|
        symbolize(v1)
      end
    elsif params.is_a?Array
      params.each do |value|
        symbolize(value)
      end
    end
  end

end
