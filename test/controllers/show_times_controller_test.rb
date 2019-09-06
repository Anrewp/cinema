require 'test_helper'

class ShowTimesControllerTest < ActionDispatch::IntegrationTest
#------------------------------------------------
  test "GET SHOWTIMES" do
#1.show showtimes
    get api_v1_show_times_path
    assert_response :success
    assert_equal JSON.parse(response.body).count, 4

#2.show showtime by movie_id    
    get api_v1_show_times_path(movie_id:5)
    assert_equal JSON.parse(response.body).count, 2
    get api_v1_show_times_path(movie_id:6)
    assert_equal JSON.parse(response.body).count, 2
    get api_v1_show_times_path(movie_id:1)
    assert_equal JSON.parse(response.body).count, 0

#3.show showtime by id
    get api_v1_show_time_path(id: 5)
    assert_response :success

#3.id not found 
    get api_v1_show_time_path(id: 254)
    assert_response :not_found
  end
#----------------------------------------------  
  test "POST SHOWTIMES" do
#1.create showtime 
  	post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-04-29T22:10:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_response :success
    get api_v1_show_times_path
    assert_equal JSON.parse(response.body).count, 5
                                                       
#2.validate set_end_time + 2h    
    get api_v1_show_time_path(id: 9)
  	assert_equal JSON.parse(response.body)['end_time'], "2018-04-30T00:10:00.000Z"

#3.validate set_tickets_available    
    assert_equal JSON.parse(response.body)['tickets_available'], 40

#4.validate showtime_available
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-03-29T20:00:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:8 exists" 

# end_time between showtime
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-03-29T19:20:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:8 exists" 

# start_time between showtime
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-03-29T21:50:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:8 exists"

# showtime start_time between start end time
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-03-29T19:50:00.000Z",
                                                        movie_id: 7,
                                                        auditorium_id: '5' }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:8 exists"

# create showtime available success
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-04-29T16:50:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_response :success
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-04-29T14:40:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_response :success
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-04-29T19:00:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_response :success

#5.set end time after create
    post api_v1_show_times_path, params: { show_time: { price: 320.0,
                                                        start_time: "2018-09-19T19:00:00.000Z",
                                                        end_time:   "2018-09-19T20:00:00.000Z",
                                                        movie_id: 5,
                                                        auditorium_id: '5' }}
    assert_response :success
    get api_v1_show_time_path(id: 13)
    assert_equal JSON.parse(response.body)['end_time'], "2018-09-19T21:00:00.000Z"
  end
#------------------------------------------------
  test "DELETE SHOWTIMES" do
#1.delete showtime
    delete api_v1_show_time_path(id: 5)
    assert_response :success

#2.auditorium not found 
    delete api_v1_show_time_path(id:234)
    assert_response :not_found
  end
#-----------------------------------------------
  test "PUT SHOWTIMES" do
#1.edit showtime
    put api_v1_show_time_path(id:5),params: { show_time: { start_time: "2018-03-29T09:00:00.000Z" }}
    assert_response :success
    put api_v1_show_time_path(id:5),params: { show_time: { start_time: "2018-03-29T10:40:00.000Z" }}
    assert_response :success
    put api_v1_show_time_path(id:5),params: { show_time: { end_time: "2018-06-29T11:40:00.000Z" }}
    assert_response :success

#2.validate showtime exitst
    put api_v1_show_time_path(id:5),params: { show_time: { start_time: "2018-03-29T11:00:00.000Z" }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:6 exists"
    put api_v1_show_time_path(id:5),params: { show_time: { start_time: "2018-03-29T13:20:00.000Z" }}
    assert_equal JSON.parse(response.body)['start_time'][0], "ShowTime id:6 exists"
  end  
#-----------------------------------------------
end