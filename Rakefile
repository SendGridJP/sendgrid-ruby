require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/sendgrid_ruby/*.rb','test/*.rb']
  #t.test_files = FileList['test/*/*.rb']
  t.verbose = true
end

