class CreateTaskStates < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE task_states AS ENUM ('planned', 'in_progress', 'delivered');
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE task_states;
    SQL
  end
end
