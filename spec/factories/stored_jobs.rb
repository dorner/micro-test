FactoryGirl.define do
  factory :stored_job do
    merchant
    state 1

    factory :indexing_job, class: 'Jobs::IndexingJob'
    factory :data_feed_job, class: 'Jobs::DataFeedJob'
  end
end

# == Schema Information
#
# Table name: stored_jobs
#
#  created_at         :datetime         not null
#  error_backtrace    :text(65535)
#  error_message      :string(2048)
#  finished_at        :datetime
#  id                 :integer          not null, primary key
#  language           :string(3)
#  merchant_id        :integer
#  options            :string(4096)
#  remote_finished_at :datetime
#  results            :text(65535)
#  retries            :integer          default("0")
#  state              :integer          default("1"), not null
#  type               :string(255)      not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_stored_jobs_on_finished_at_and_state  (finished_at,state)
#  index_stored_jobs_on_merchant_id_and_state  (merchant_id,state)
#
