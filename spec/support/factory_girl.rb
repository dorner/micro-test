RSpec.configure do |config|
    # Sets up Factory Girl this allows to use factory girl methods without specifing class names like 'build(:stored_job)'
  config.include FactoryGirl::Syntax::Methods
end