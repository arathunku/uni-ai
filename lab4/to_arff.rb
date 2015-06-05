require 'pry'

input = "output"


def files(input)
  Dir[input + '/**/*'].select { |f| !File.directory?(f) }
end

header = <<-EOS
@relation words-occurances

EOS

categories = []
words_index = {
  # category { words: {word: { count: 1, categories: [], docs_count: 0}},}
}

files(input).each do |file_path|
  doc_id, category, *words = File.open(file_path).read().split(',')

  words.each_slice(2).each do |group|
    word, count = group
    categories.push(category)
    words_index[doc_id] ||= { words: {}, category: category }
    element = words_index[doc_id][:words]
    element[word] = { count: count.to_i, docs_count: 1 }
  end
end

most_freq_words = words_index.values.map do |value|
  value[:words]
end.flatten.inject({}) do |coll, words|
  words.each do |key, value|
    coll[key] ||= { count: 0, docs_count: 0}
    coll[key][:count] += value[:count]
    coll[key][:docs_count] += value[:docs_count]
  end
  coll
end.map do |(key, value)|
  [key, value[:count], value[:docs_count]]
end.sort do |a, b|
  b[1] <=> a[1]
end.map { |e| e[0] }.
flatten.uniq.first(10000)


header += most_freq_words.map do |word|
  "@attribute #{word} NUMERIC"
end.join("\n")

# header += "\n@attribute doc_id string"
header += "\n@attribute class {#{categories.uniq.join(',')}}\n"

header += "\n@data\n"
words_index.each do |(key, value)|
  words = most_freq_words.map {|w| words_index[key][:words].fetch(w, {}).fetch(:count, 0) }.join(',')
  header += "#{words},#{value[:category]}\n"
end

File.write("data.arff", header)
