Then /^i should wait (\d*) seconds$/ do |i|
  sleep i.to_i
end
Then /^it should fail$/ do
  false.should be_true
end