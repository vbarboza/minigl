require 'rake/testtask'

Rake::TestTask.new do |t|
	t.libs << "test"
	t.test_files = FileList['test/*_tests.rb']
	t.verbose = true
end

task :doc do |t|
	sh "rdoc lib/minigl/*.rb"
end
