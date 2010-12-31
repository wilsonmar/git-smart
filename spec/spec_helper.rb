require 'ruby-debug'

require File.dirname(__FILE__) + '/../lib/git-smart.rb'

WORKING_DIR = File.dirname(__FILE__) + '/working'

RSpec.configure do |config|
  config.before :each do
    FileUtils.mkdir_p WORKING_DIR
  end

  config.after :each do
    FileUtils.rm_rf WORKING_DIR
  end
end

def run_command(dir, command, args = [])
  require 'stringio'
  $stdout = stdout = StringIO.new

  Dir.chdir(dir) { GitSmart.run(command, args) }

  $stdout = STDOUT
  stdout.string.split("\n")
end

RSpec::Matchers.define :report do |expected|
  failure_message_for_should do |actual|
    "expected to see #{expected.inspect}, got \n\n#{actual.map { |line| "  #{line}" }.join("\n")}"
  end
  failure_message_for_should_not do |actual|
    "expected not to see #{expected.inspect} in \n\n#{actual.map { |line| "  #{line}" }.join("\n")}"
  end
  match do |actual|
    actual.any? { |line| line[expected] }
  end
end
