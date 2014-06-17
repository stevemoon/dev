https://github.com/yaworsw/euler-manager
gem install euler-manager

usage:
Euler manager has 5 commands:

new initializes a solution. This typically means creating the directory for the solution and populating it with some files.

$ euler new [problem_id] [language]

desc shows a problem's prompt.

$ euler desc [problem_id]

run executes a solution.

$ euler run [problem_id] [language]

test runs a solution to see if it is correct.

$ euler test [problem_id] [language]

test_all runs all of your solutions to see if they are correct.

$ euler test_all

If you do not pass a problem id and language to the desc, run, or test commands Euler manager will use the directory it was invoked from to try to guess which problem id and language to use. So if you want to run the ruby solution for problem number 1 then you can just run $ euelr run from 1/ruby (by default) and Euler manager will run the ruby solution for problem 1.
