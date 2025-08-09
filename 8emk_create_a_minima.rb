# 8emk_create_a_minima.rb
# A minimalist automation script analyzer

# Require necessary libraries
require 'fileutils'
require 'csv'

# Define constants for script types
SCRIPT_TYPES = %w[bash powershell python ruby]

# Define a class for script analysis
class ScriptAnalyzer
  attr_accessor :script_path, :script_type

  def initialize(script_path)
    @script_path = script_path
    @script_type = detect_script_type(script_path)
  end

  def detect_script_type(script_path)
    # Detect script type based on file extension
    File.extname(script_path).downcase.sub('.', '').tap do |ext|
      raise "Unsupported script type: #{ext}" unless SCRIPT_TYPES.include?(ext)
    end
  end

  def analyze
    # Basic analysis: count number of lines and characters
    lines = File.readlines(script_path).count
    chars = File.readlines(script_path).join.size

    # Create a CSV row for the analysis result
    [script_path, script_type, lines, chars]
  end
end

# Define a class for script analyzer manager
class ScriptAnalyzerManager
  def self.analyze_all(scripts_dir)
    # Create a CSV file for the analysis result
    csv_file = "#{scripts_dir}/analysis_result.csv"
    CSV.open(csv_file, 'w', headers: true) do |csv|
      csv << %w[Script_Path Script_Type Lines Characters]

      # Iterate over all script files in the directory
      Dir.glob("#{scripts_dir}/*.*").each do |script_path|
        analyzer = ScriptAnalyzer.new(script_path)
        csv << analyzer.analyze
      end
    end
  end
end

# Usage example
if __FILE__ == $PROGRAM_NAME
  scripts_dir = './scripts'
  ScriptAnalyzerManager.analyze_all(scripts_dir)
end