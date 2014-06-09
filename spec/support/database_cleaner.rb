RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)#, {:except => %w[capabilities roles role_capabilities]}
  end

  #config.before(:each) do
    #DatabaseCleaner.strategy = :transaction
  #end

  #config.before(:each) do
    #DatabaseCleaner.strategy = :truncation, {:except => %w[capabilities roles role_capability]}
    #end

  #config.before(:each) do
    #DatabaseCleaner.start
    #end
  
  #config.after(:each) do
    #DatabaseCleaner.clean
    #end

end