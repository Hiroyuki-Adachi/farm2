class AddOrganizationToSections < ActiveRecord::Migration[8.1]
  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    add_reference :sections, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"

    section_orgs = select_all(<<~SQL.squish).to_a
      SELECT section_id, organization_id
        FROM (
          SELECT homes.section_id, homes.organization_id
            FROM homes
           WHERE homes.section_id IS NOT NULL
          UNION
          SELECT schedule_sections.section_id, schedules.organization_id
            FROM schedule_sections
            INNER JOIN schedules ON schedules.id = schedule_sections.schedule_id
        ) refs
       WHERE section_id IS NOT NULL
       ORDER BY section_id, organization_id
    SQL

    section_orgs.group_by { |row| row["section_id"].to_i }.each do |section_id, rows|
      org_ids = rows.map { |row| row["organization_id"].to_i }.uniq
      primary_org_id = org_ids.include?(default_org_id) ? default_org_id : org_ids.first

      execute <<~SQL.squish
        UPDATE sections
           SET organization_id = #{primary_org_id}
         WHERE id = #{section_id}
      SQL

      org_ids.reject { |org_id| org_id == primary_org_id }.each do |org_id|
        new_section_id = select_value(<<~SQL.squish).to_i
          INSERT INTO sections (
            name, display_order, work_flag, deleted_at, created_at, updated_at, organization_id
          )
          SELECT name, display_order, work_flag, deleted_at, created_at, updated_at, #{org_id}
            FROM sections
           WHERE id = #{section_id}
          RETURNING id
        SQL

        execute <<~SQL.squish
          UPDATE homes
             SET section_id = #{new_section_id}
           WHERE section_id = #{section_id}
             AND organization_id = #{org_id}
        SQL

        execute <<~SQL.squish
          UPDATE schedule_sections
             SET section_id = #{new_section_id}
            FROM schedules
           WHERE schedule_sections.schedule_id = schedules.id
             AND schedule_sections.section_id = #{section_id}
             AND schedules.organization_id = #{org_id}
        SQL
      end
    end
  end

  def down
    remove_reference :sections, :organization, foreign_key: true
  end
end
