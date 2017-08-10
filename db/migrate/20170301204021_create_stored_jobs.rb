class CreateStoredJobs < ActiveRecord::Migration[5.0]
  def change
    create_table 'stored_jobs', force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string 'type', null: false
      t.datetime 'finished_at'
      t.integer 'state', default: 1, null: false
      t.text 'results', limit: 65535
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'error_message', limit: 2048
      t.text 'error_backtrace', limit: 65535
      t.string 'options', limit: 4096
      t.integer 'retries', limit: 1, default: 0
      t.index %w(finished_at state), name: 'index_stored_jobs_on_finished_at_and_state', using: :btree

    end
  end
end
