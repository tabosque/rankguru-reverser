require 'csv'
require 'optparse'

# Original RankGuru CSV file
original_csv_file = ARGV[0]

# Command options
option={}
OptionParser.new do |opt|
  opt.on('--only-ranking', 'Write only ranking') { |v| option[:only_ranking] = v }
  opt.on('--without-header', 'Without header row') { |v| option[:without_header] = v }
  opt.parse!(ARGV)
end

# Read RankGuru CSV file
new_csv_array = Array.new(){ Array.new() }
index = 0
CSV.foreach(original_csv_file, { encoding: "UTF-8", col_sep: ", ", quote_char: '"' }) do |row|
    if !option[:without_header] || (option[:without_header] && $. != 1)
      if option[:only_ranking]
        new_csv_array[index] = row[3..-1].reverse
      else
        new_csv_array[index] = [row[0], row[1], row[2]]
        new_csv_array[index].concat(row[3..-1].reverse)
      end
      index += 1
    end
end

# Write RankGuru reverse CSV file
reverse_csv_file = original_csv_file.gsub(".csv", "_reverse.csv")
CSV.open(reverse_csv_file, "wb", { encoding: "UTF-8" }) do |csv|
  new_csv_array.each_with_index  do |row, i|
    csv << new_csv_array[i].map
  end
end