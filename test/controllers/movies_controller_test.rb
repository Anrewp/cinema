require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
#------------------------------------------------
  test "GET MOVIES" do
#1.show movies
    get api_v1_movies_path
    assert_response :success

#2.show movie by id    
    get api_v1_movie_path(id: 5)
    assert_response :success

#3.id not found   
    get api_v1_movie_path(id: 1)
    assert_response :not_found

#4.show movie by title    
    get title_api_v1_movies_path(title: 'Avengers')
    assert_response :success

#5.title not found
    get title_api_v1_movies_path(title: 'No movie')
    assert_response :not_found
  end
#----------------------------------------------  
  test "POST MOVIES" do
#1.create movie 
  	post api_v1_movies_path, params: { movie: { title: 'Bob 13' }}
  	assert_response :success

#2.title validation uniqueness 
  	post api_v1_movies_path, params: { movie: { title: 'Bob 13' }}
    assert_equal JSON.parse(response.body)['title'][0], "has already been taken"

#3.title validation presence
    post api_v1_movies_path, params: { movie: { title: '' }}
    assert_equal JSON.parse(response.body)['title'][0], "can't be blank"
  end
#------------------------------------------------
  test "DELETE MOVIES" do
#1.delete movie
    delete api_v1_movie_path(id: 5)
    assert_response :success

#2.movie not found 
    delete api_v1_movie_path(id:234)
    assert_response :not_found
  end
#-----------------------------------------------
  test "PUT MOVIES" do
#1.edit movie
    put api_v1_movie_path(id:5),params: { movie: { title: 'Bob 13' }}
    assert_response :success

#2.movie not found
    put api_v1_movie_path(id:1),params: { movie: { title: 'Bob 13' }}
    assert_response :not_found

#3.title validation presence
    put api_v1_movie_path(id:5),params: { movie: { title: '' }}
    assert_equal JSON.parse(response.body)['movie'], "Title can't be blank"

#4.title validation uniqueness
    put api_v1_movie_path(id:5),params: { movie: { title: 'It2' }}
    assert_equal JSON.parse(response.body)['movie'], "Title has already been taken"
  end
#-----------------------------------------------
end