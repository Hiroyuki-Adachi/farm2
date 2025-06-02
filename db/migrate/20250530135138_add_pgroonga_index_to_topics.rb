class AddPgroongaIndexToTopics < ActiveRecord::Migration[8.0]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS pgroonga;'
    execute <<~SQL
      CREATE INDEX index_topics_on_title_and_content_pgroonga
      ON topics
      USING pgroonga ((coalesce(title, '') || ' ' || coalesce(content, '')));
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX index_topics_on_title_and_content_pgroonga;
    SQL
  end
end
