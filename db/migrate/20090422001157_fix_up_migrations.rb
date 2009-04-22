class FixUpMigrations < ActiveRecord::Migration
  def self.up
    say_with_time %{
      If you are transitioning from 0.6.9 to 0.7.1, these migrations
      were lost. We're not worried if the columns already exist.
      } do
      maybe_add_column 'duplicate column name', 
        :pages, :is_preview, :boolean, :default => false
      maybe_add_column 'duplicate column name', 
        :snippets, :is_preview, :boolean, :default => false
      maybe_add_column 'duplicate column name', 
        :layouts, :is_preview, :boolean, :default => false
      remove_column :page_part_revisions, :page_part_id
    end
  end

  def self.down
  end

private

  def self.method_missing(m, *args)
    if m.to_s =~ /^maybe_(.*)/
      begin
        whoops = args.shift
        self.send($1, *args)
      rescue ActiveRecord::StatementInvalid => e
        if e.to_s.downcase.include? whoops.downcase
          say '  skipping'
          true
        else
          raise e
        end
      end
    else
      super
    end
  end

end
