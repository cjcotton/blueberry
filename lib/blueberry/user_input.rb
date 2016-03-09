require 'trollop'

class UserInput

  # Parses user provided flags.
  def self.parse(args)

    options = {}
    opts = Trollop::options do
      opt :list,     "list all templates"
      opt :hostname, "ex: test.domain.com", :type => :string
      opt :role,     "web, database, etc",  :type => :string
    end

    list() if opts[:list] == true
    options = opts

  end

  # If the user requests a list of roles from the CLI, this function
  # will print out any files located under templates/.
  def self.list()

    templates = []
    relative_path = File.expand_path(File.dirname(__FILE__))
    Dir.foreach(relative_path + "/../blueberry/templates/") do |item|
      next if item == '.' or item == '..'
      templates << " - " + item.gsub(".erb", '') + "\n"
    end
    puts templates.join
    abort

  end

end #End UserInput
