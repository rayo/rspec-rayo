$LOAD_PATH.unshift(File.dirname(__FILE__))
%w{
  rspec-tropo2/tropo2-driver
  rspec-tropo2/tropo1-driver
  rspec-tropo2/rspec-tropo2
}.each { |lib| require lib }