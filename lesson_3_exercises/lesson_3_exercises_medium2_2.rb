
munsters = {
  "Herman" => {"age" => 32, "gender" => "male"},
  "Lily" => {"age" => 30, "gender" => "female"},
  "Grandpa" => {"age" => 402, "gender" => "male"},
  "Eddie" => {"age" => 10, "gender" => "male"}
}

munsters.each do |name, description|
  puts "#{name} is a #{description["age"]} year old #{description["gender"]}."
end