class BaseQuery
  def self.call(*args, **kwargs)
    new(*args, **kwargs).execute
  end
  
  def execute
    results = ActiveRecord::Base.connection.exec_query(build_query.to_sql)
    results.map { |row| result_class.new(row.symbolize_keys) }
  end
  
  private
  
  def build_query
    raise NotImplementedError, "Subclasses must implement `build_query`"
  end

  def result_class
    raise NotImplementedError, "#{self.class} must define a result_class method"
  end
end
