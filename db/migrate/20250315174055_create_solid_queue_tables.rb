class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    # Jobs table
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.string :concurrency_key
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:active_job_id], name: "index_solid_queue_jobs_on_active_job_id"
      t.index [:queue_name, :finished_at], name: "index_solid_queue_jobs_on_queue_name_and_finished_at"
      t.index [:scheduled_at], name: "index_solid_queue_jobs_on_scheduled_at", where: "finished_at IS NULL"
      t.index [:concurrency_key], name: "index_solid_queue_jobs_on_concurrency_key", where: "finished_at IS NULL"
    end

    # Semaphores table
    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false
      t.integer :value, default: 1, null: false
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:key, :value], name: "index_solid_queue_semaphores_on_key_and_value"
      t.index [:expires_at], name: "index_solid_queue_semaphores_on_expires_at"
    end

    # Blocked executions table
    create_table :solid_queue_blocked_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.string :queue_name, null: false
      t.string :concurrency_key, null: false
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:expires_at], name: "index_solid_queue_blocked_executions_on_expires_at"
      t.index [:concurrency_key, :queue_name], name: "index_solid_queue_blocked_executions_concurrency"
    end

    # Ready executions table
    create_table :solid_queue_ready_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :created_at, null: false

      t.index [:priority, :created_at], name: "index_solid_queue_ready_executions_for_processing"
      t.index [:queue_name, :priority, :created_at], name: "index_solid_queue_ready_executions_for_queues"
    end

    # Scheduled executions table
    create_table :solid_queue_scheduled_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :scheduled_at, null: false

      t.index [:scheduled_at, :priority], name: "index_solid_queue_scheduled_executions_for_release"
    end

    # Failed executions table
    create_table :solid_queue_failed_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.text :error
      t.datetime :created_at, null: false
    end

    # Pauses table
    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false
      t.datetime :created_at, null: false

      t.index [:queue_name], name: "index_solid_queue_pauses_on_queue_name", unique: true
    end

    # Process heartbeats table
    create_table :solid_queue_process_heartbeats do |t|
      t.string :pid, null: false
      t.string :hostname, null: false
      t.string :supervisor_name, null: false
      t.text :work_queue_names, null: false
      t.datetime :heartbeat_at, null: false
      t.datetime :created_at, null: false

      t.index [:supervisor_name, :pid, :hostname], name: "index_solid_queue_process_heartbeats_on_supervisor_pid_hostname", unique: true
      t.index [:heartbeat_at], name: "index_solid_queue_process_heartbeats_on_heartbeat_at"
    end

    # Recurring executions table
    create_table :solid_queue_recurring_executions do |t|
      t.string :name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.string :schedule
      t.datetime :scheduled_at, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:name], name: "index_solid_queue_recurring_executions_on_name", unique: true
      t.index [:scheduled_at], name: "index_solid_queue_recurring_executions_on_scheduled_at"
    end
  end
end
