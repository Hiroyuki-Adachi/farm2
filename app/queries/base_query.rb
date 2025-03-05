class BaseQuery
  def self.call(**args)
    new(**args).execute
  end
  
  def execute
    raise NotImplementedError, "#{self.class} must define a Result struct" unless self.class.const_defined?(:Result)

    results = ActiveRecord::Base.connection.exec_query(build_query.to_sql)
    results.map { |row| self.class::Result.new(row.symbolize_keys) }
  end
  
  private
  
  def build_query
    raise NotImplementedError, "Subclasses must implement `build_query`"
  end
end
