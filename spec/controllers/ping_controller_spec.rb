RSpec.describe PingController, :type => :controller do
  describe "GET index" do
    it "should return status 200" do
      get :index
      expect(response.status).to eq(200)
    end

    it "should return the correct JSON response" do
      get :index
      expect(response.body).to eq({:status => 'ok'}.to_json)
    end
  end
end
