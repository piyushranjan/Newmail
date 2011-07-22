desc "Dump all the data from DB to fixtures in YML format"
namespace :db do
  namespace :fixtures do
    task :dump => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(Rails.env)
      base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'test', 'fixtures')
      fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

      Dir.entries(File.join(RAILS_ROOT, "app", "models")).each{|filename|        
        if /\.rb$/.match(filename)
          model = Kernel.const_get(filename.gsub(".rb", "").camelcase)
          if model.ancestors.include?(ActiveRecord::Base) and model.table_exists?
            begin
              puts "Doing #{model}"
              file = File.open(File.join("test", "fixtures", model.table_name+".yml"), "w")
              counter = 1
              model.find_in_batches(:batch_size => 5000){|rows|
                rows.each{|row|
                  file.puts "#{counter}:"
                  file.puts row.attributes.to_yaml.split("\n")[1..-1].collect{|x| "\s\s"+x}.join("\n")
                  counter+=1
                }
              }
              file.close
              puts "Created a file with #{counter} rows"
            rescue
              puts "Ooops! Cannot dump #{model}"
            end
          end
        end
      }
    end
  end
end
