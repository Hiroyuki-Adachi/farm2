module ActiveRecord
  class Relation
    alias :initialize_without_cpk :initialize
    def initialize(klass, table, values = {})
      initialize_without_cpk(klass, table, values)
      add_cpk_support if klass && klass.composite?
    end

    alias :initialize_copy_without_cpk :initialize_copy
    def initialize_copy(other)
      initialize_copy_without_cpk(other)
      add_cpk_support if klass.composite?
    end

    def add_cpk_support
      extend CompositePrimaryKeys::CompositeRelation
    end

    alias :where_values_hash_without_cpk :where_values_hash
    def where_values_hash(relation_table_name = table_name)
      # CPK
      nodes_from_and = where_values.grep(Arel::Nodes::And).map { |and_node|
        and_node.children.grep(Arel::Nodes::Equality)
      }.flatten

      # CPK
      # equalities = where_values.grep(Arel::Nodes::Equality).find_all { |node|
      #   node.left.relation.name == relation_table_name
      # }
      equalities = (nodes_from_and + where_values.grep(Arel::Nodes::Equality)).find_all { |node|
        node.left.relation.name == relation_table_name
      }

      binds = Hash[bind_values.find_all(&:first).map { |column, v| [column.name, v] }]

      Hash[equalities.map { |where|
        name = where.left.name
        [name, binds.fetch(name.to_s) {
          case where.right
          when Array then where.right.map(&:val)
          else
            where.right.val
          end
        }]
      }]
    end

    def _update_record(values, id, id_was)
      substitutes, binds = substitute_values values

      # CPK
      um = if self.composite?
        relation = @klass.unscoped.where(cpk_id_predicate(@klass.arel_table, @klass.primary_key, id_was || id))

        relation.arel.compile_update(substitutes, @klass.primary_key)
      else
        scope = @klass.unscoped

        if @klass.finder_needs_type_condition?
          scope.unscope!(where: @klass.inheritance_column)
        end

        relation = scope.where(@klass.primary_key => (id_was || id))
        binds += relation.bind_values

        relation.arel.compile_update(substitutes, @klass.primary_key)
      end

      @klass.connection.update(
        um,
        'SQL',
        binds)
    end
  end
end
