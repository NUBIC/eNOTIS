class ENActiveRecordPerformer
  @queue = :low
  def self.perform(klass, obj_id, method, *args)
    klass.constantize.find(obj_id).send(method, *args)
  end
end
