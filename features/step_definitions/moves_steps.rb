 Given(/^the following movies exist:$/) do |movies_table|
 	movies_table.hashes.each do |movie|
 		Movie.create!(:title => movie[:title], :rating => movie[:rating],
 			            :director => movie[:director],:release_date => movie[:release_date])

 end
end


Given(/^I am on the home page$/) do
  visit movies_path
end

Then(/^the movies are order by "(.*?)":$/) do |arg1, table|
   show_table = page.all('table tbody tr').map do |row|
      row.first('td').text
   end
   expect_table = table.raw.flatten
   expect_table.shift
   puts expect_table.to_s
   expect(show_table).to eq expect_table

end
When(/^I go to the edit page for "(.*?)"$/) do |title|
  movie = Movie.find_by(title: title)
	visit edit_movie_path(movie)
  expect(page).to have_content('Edit Existing Movie')
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |title, director|
       movie = Movie.find_by(title: title)
       expect(movie.director).to eq director
       expect(page).to have_content("Director: #{director}")
end
 
Then(/^I should see "(.*?)" as director of "(.*?)"$/) do |director,title|
      page.all('table tbody tr').each do |row|
        cells = row.all('td').map do |cell|
          cell.text
        end
        if cells[0] == title
          expect(cells[2]).to eq director
        end
      end
end

Given(/^I am on the details page for "(.*?)"$/) do |title|
  movie = Movie.find_by(title: title)
	visit movie_path(movie)
  expect(page).to have_content('Details about')
end

Then(/^I should be on the Similar Movies page for "(.*?)"$/) do  |title|
  movie = Movie.find_by(title: title)
  current_path = URI.parse(current_url).path
  expect(current_path).to eq movie_similar_path(movie)
  expect(page).to have_content('Similar Movies')
end

Then(/^I should be on the edit page for "(.*?)"$/) do |title|
  movie = Movie.find_by(title: title)
  current_path = URI.parse(current_url).path
  expect(current_path).to eq edit_movie_path(movie)
  expect(page).to have_content('Edit Existing Movie')
end

Then(/^I should be on the home page$/) do
  current_path = URI.parse(current_url).path
  expect(current_path).to eq movies_path
  expect(page).to have_content('All Movies')
end
Then(/^I should be on the details page for "(.*?)"$/) do |title|
  movie = Movie.find_by(title: title)
  current_path = URI.parse(current_url).path
  expect(current_path).to eq movie_path(movie)
  expect(page).to have_content('Details about')

end

Then(/^I should see movies "(.*?)" and "(.*?)"$/) do |arg1, arg2|
  show_table = page.all('table tbody tr').map do |row|
    row.all('td').map do |cell|
      cell.text
    end
  end
  expect(show_table[0][0]).to eq arg1
  expect(show_table[1][0]).to eq arg2
end

Then(/^I should not see "(.*?)" in the table of movies$/) do |arg1|
  expect(page).to have_content(arg1, count: 1)
end

Then(/^I should be on the new page$/) do
  current_path = URI.parse(current_url).path
  expect(current_path).to eq new_movie_path
  expect(page).to have_content('Create New Movie')
end