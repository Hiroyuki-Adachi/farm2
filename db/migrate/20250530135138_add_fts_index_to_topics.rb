class AddFtsIndexToTopics < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE INDEX index_topics_on_title_and_content_fts
      ON topics
      USING GIN (to_tsvector('japanese', coalesce(title, '') || ' ' || coalesce(content, '')));
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX index_topics_on_title_and_content_fts;
    SQL
  end
end
