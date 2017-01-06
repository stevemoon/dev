#!/usr/local/bin/ruby
#
# Written by Steve Moon 11/28/2016
# Copyright 2016
# Permission is granted to modify and redistribute under the terms of the MIT License

# Convert the HAM radio question pools as published by http://www.ncvec.org/
# into machine-readable CSV files
# CSV file output is in the format of:
# QuestionID, Question, Diagram (if any), Correct answer, 3 dummy answers

# To use:
# Download the appropriate word document
# Paste all of the lines into a text document
# Delete the first few hundred lines detailing sections etc. - just get to the
# meat of the questions.
# ./convert filename.txt > filename.CSV

file = ARGV[0]
inrecord = false
question_next = false
id = ""
correct = ""
question = ""
figure = ""
answers = []
open(file).each do |line|
  line.chomp!
  if question_next
    question = line
    question_next = false
    if question =~ /.+in [Ff]igure /
      figure = question.gsub(/.+[Ff]igure /, "")
      figure = figure.gsub(/ .+$/, "")
      figure = figure.gsub(/\W$/, "")
    end
  end
  if line =~ /^\w\d\w\d\d \(/
    inrecord = true
    question_next = true
    question = ""
    correct = ""
    figure = ""
    answers = []
    id = line[0,5]
    correct = line[7]
  else if line =~ /^~~/
    inrecord = false
    print "\"#{id}\",\"#{question}\",\"#{figure}\",\"#{correct}\""
    answers.each do |answer|
      print ",\"#{answer}\""
    end
    puts
    end
  end
  if line[0] == correct
    correct = line[3,line.length]
  else if line[0] =~ /A|B|C|D/
    answers << line[3,line.length]
  end
end
end
