class StoredJobsController < ApplicationController

  append_view_path 'job_controller'

  def index
    @jobs = StoredJob.filter(params)
    @queue_attributes = AwsHelper.get_queue_attributes
  end

  def queue_test_job
    Jobs::TestJob.new.queue_job
    redirect_to :back, notice: 'Test job queued!'
  end

end
