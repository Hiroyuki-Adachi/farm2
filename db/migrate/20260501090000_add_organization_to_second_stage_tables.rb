class AddOrganizationToSecondStageTables < ActiveRecord::Migration[8.1]
  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    add_reference :schedules, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :tasks, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :total_costs, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :fixes, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"

    execute <<~SQL.squish
      UPDATE schedules
         SET organization_id = workers.organization_id
        FROM workers
       WHERE schedules.created_by = workers.id
    SQL

    execute <<~SQL.squish
      UPDATE tasks
         SET organization_id = COALESCE(creators.organization_id, assignees.organization_id, task_templates.organization_id, #{default_org_id})
        FROM tasks source_tasks
        LEFT JOIN workers creators ON creators.id = source_tasks.creator_id
        LEFT JOIN workers assignees ON assignees.id = source_tasks.assignee_id
        LEFT JOIN task_templates ON task_templates.id = source_tasks.task_template_id
       WHERE tasks.id = source_tasks.id
    SQL

    execute <<~SQL.squish
      UPDATE total_costs
         SET organization_id = works.organization_id
        FROM works
       WHERE total_costs.work_id = works.id
    SQL

    execute <<~SQL.squish
      UPDATE total_costs
         SET organization_id = lands.organization_id
        FROM lands
       WHERE total_costs.work_id IS NULL
         AND total_costs.land_id = lands.id
    SQL

    execute <<~SQL.squish
      UPDATE total_costs
         SET organization_id = homes.organization_id
        FROM seedling_homes
        INNER JOIN homes ON homes.id = seedling_homes.home_id
       WHERE total_costs.work_id IS NULL
         AND total_costs.land_id IS NULL
         AND total_costs.seedling_home_id = seedling_homes.id
    SQL

    execute <<~SQL.squish
      UPDATE fixes
         SET organization_id = workers.organization_id
        FROM workers
       WHERE fixes.fixed_by = workers.id
    SQL

    add_index :schedules, [:organization_id, :worked_at]
    add_index :tasks, [:organization_id, :task_status_id]
    add_index :total_costs, [:organization_id, :term, :occurred_on]

    change_column_default :schedules, :organization_id, 1
    change_column_default :tasks, :organization_id, 1
    change_column_default :total_costs, :organization_id, 1
    change_column_default :fixes, :organization_id, 1

    execute "ALTER TABLE fixes DROP CONSTRAINT IF EXISTS fixes_pkey"
    execute "ALTER TABLE fixes ADD PRIMARY KEY (organization_id, term, fixed_at)"
  end

  def down
    execute "ALTER TABLE fixes DROP CONSTRAINT IF EXISTS fixes_pkey"
    execute "ALTER TABLE fixes ADD PRIMARY KEY (term, fixed_at)"

    remove_index :total_costs, column: [:organization_id, :term, :occurred_on]
    remove_index :tasks, column: [:organization_id, :task_status_id]
    remove_index :schedules, column: [:organization_id, :worked_at]

    remove_reference :fixes, :organization, foreign_key: true
    remove_reference :total_costs, :organization, foreign_key: true
    remove_reference :tasks, :organization, foreign_key: true
    remove_reference :schedules, :organization, foreign_key: true
  end
end
