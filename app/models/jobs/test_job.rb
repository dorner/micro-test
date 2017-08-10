class Jobs::TestJob < StoredJob

  def run_job(options={})
    { result_text: "I've done it!" }
  end

end
