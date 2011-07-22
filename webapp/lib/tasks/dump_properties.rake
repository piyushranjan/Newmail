desc "Dump all the data from DB to fixtures in YML format"
namespace :db do
  namespace :properties do
    task :write => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(Rails.env)
      base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'test', 'fixtures')
      fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

      Dir.entries(File.join(RAILS_ROOT, "app", "models")).each{|filename|        
        if /\.rb$/.match(filename)
          model = Kernel.const_get(filename.gsub(".rb", "").camelcase)
          if model.ancestors.include?(ActiveRecord::Base) and model.table_exists?
            begin
              lines = []
	      class_line = 0
              File.open(File.join(RAILS_ROOT, "app", "models", filename), "r"){|f| 
                puts model.to_s
                f.readlines.each_with_index{|line, idx|
                  if line.include?("class #{model}") and line.include?("< ActiveRecord::Base")
                    class_line = idx 
                  end
                  lines << line.rstrip
                }
              }
              properties = []
              model.columns.each{|column|
                property_line = "  property :#{column.name}, :#{column.type}, :nullable => #{column.null}#{', :primary => true' if column.primary}"

                unless lines.include?(property_line)
                  properties.push(property_line)
                end
              }
              File.open(File.join(RAILS_ROOT, "app", "models", filename), "w"){|f|
                [lines[0..class_line], properties, lines[class_line+1..-1]].flatten.each{|line|
                  f.puts line
                }
              }
           rescue Exception => e
              puts e.message
              puts e.backtrace
              puts "Ooops! Could not do #{model}"
            end
          end
        end
      }
    end
  end
end
