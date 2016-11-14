Feature: search for movies by director

  As a movie buff
  So that the movies are well managed
  I want to view, modify and delete the movies

Background: movies in database

  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |


Scenario: filter movies by ratings
  Given I am on the home page
  And  I check "ratings[PG]"
  And  I press "Refresh"
  Then I should see movies
  |title       |
  |Star Wars   |
  |Blade Runner|


Scenario: sort movies by title
  Given I am on the home page
  And  I follow "Movie Title"
  Then I should see movies order by "title":
  |title       |
  |Alien       |
  |Blade Runner|
  |Star Wars   |
  |THX-1138    |

Scenario: sort movies by release_date
  Given I am on the home page
  And  I follow "Release Date"
  Then I should see movies order by "release_date":
  |title       |
  |THX-1138    |
  |Star Wars   |
  |Alien       |
  |Blade Runner|

Scenario: current setting of filter and sort is remembered:
  Given I am on the home page
  When  I check "ratings[R]"
  And  I press "Refresh"
  And  I follow "Release Date"
  When I follow "More about Alien"
  Then I should be on the details page for "Alien"
  When I follow "Back to movie list"
  Then I should see movies order by "release_date":
  |title       |
  |THX-1138    |
  |Alien       |


Scenario: new setting of filter and sort will take effective:
  Given I am on the home page
  When  I check "ratings[R]"
  And  I press "Refresh"
  And  I follow "Release Date"
  Then I should see movies order by "release_date":
  |title       |
  |THX-1138    |
  |Alien       |
  When  I follow "Movie Title"
  Then I should see movies order by "title":
  |title       |
  |Alien       |
  |THX-1138    |
  When I uncheck "ratings[R]"
  And  I press "Refresh"
  Then I should see movies
  |title       |
  |Alien       |
  |THX-1138    |

Scenario: add a new movie
  Given I am on the home page
  And  I follow "Add new movie"
  And  I fill in "Title" with "Test"
  And  I fill in "Director" with "No"
  And  I press "Save"
  Then I should be on the home page
  And I should see "Test was successfully created"

Scenario: The title should not be blank for new movie
  Given I am on the home page
  When  I follow "Add new movie"
  Then I should be on the new page
  When I press "Save"
  And I should see "Validation failed"

Scenario: delete an existing movie
  Given I am on the details page for "Star Wars"
  And  I press "Delete"
  Then I should be on the home page
  And  I should see "Movie 'Star Wars' deleted"
  And I should not see "Star Wars" in the table of movies

Scenario: The title should not be blank for updation
  When I go to the edit page for "Alien"
  And  I fill in "Title" with ""
  When I press "Update Movie Info"
  Then I should be on the edit page for "Alien"
  And I should see "Validation failed"