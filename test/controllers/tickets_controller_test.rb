require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
#------------------------------------------------
  test "GET TICKETS" do
#1.show tickets
    get api_v1_tickets_path
    assert_response :success
    assert_equal JSON.parse(response.body).count, 5

#2.show ticket by id    
    get api_v1_ticket_path(id: 5)
    assert_response :success

#3.id not found   
    get api_v1_ticket_path(id: 1)
    assert_response :not_found

#2.show tickets by showtime_id    
    get api_v1_tickets_path(showtime_id:5)
    assert_equal JSON.parse(response.body).count, 2
    get api_v1_tickets_path(showtime_id:6)
    assert_equal JSON.parse(response.body).count, 3
    get api_v1_tickets_path(showtime_id:1)
    assert_equal JSON.parse(response.body).count, 0
  end
#----------------------------------------------  
  test "POST TICKETS" do
#1.create ticket 
  	post api_v1_tickets_path, params: { ticket: { email: 'abra@gmail.com',
                                                  seat: 7,
                                                  show_time_id: 5 }}
  	assert_response :success
    get api_v1_tickets_path
    assert_response :success
    assert_equal JSON.parse(response.body).count, 6

#2. tickets_available decrease -1
    get api_v1_show_time_path(id:5)
    assert_equal JSON.parse(response.body)['tickets_available'], 39

#3.seat validation uniqueness 
  	post api_v1_tickets_path, params: { ticket: { email: 'abra@gmail.com',
                                                  seat: 7,
                                                  show_time_id: 5 }}
    assert_equal JSON.parse(response.body)['seat'][0], "has already been taken"

#4.seat validation invalid_seat
    post api_v1_tickets_path, params: { ticket: { email: 'abra@gmail.com',
                                                  seat: 43,
                                                  show_time_id: 5 }}
    assert_equal JSON.parse(response.body)['seat'][0], "There is no such seat"

#4.email validation presence
    post api_v1_tickets_path, params: { ticket: { email: '',
                                                  seat: 23,
                                                  show_time_id: 5 }}
    assert_equal JSON.parse(response.body)['email'][0], "can't be blank"    
  end
#------------------------------------------------
  test "DELETE TICKETS" do
#1.delete ticket
    delete api_v1_ticket_path(id: 5)
    assert_response :success

#2.ticket not found 
    delete api_v1_ticket_path(id:234)
    assert_response :not_found
  end
#-----------------------------------------------
  test "PUT TICKETS" do
#1.edit ticket
    put api_v1_ticket_path(id:5),params: { ticket: { email: 'adrian@gmail.com',
                                                     seat: 23,
                                                     show_time_id: 5 }}
    assert_response :success

#2.ticket not found
    put api_v1_ticket_path(id:1),params: { ticket: { email: 'adrian@gmail.com',
                                                     seat: 23,
                                                     show_time_id: 5 }}
    assert_response :not_found

#3.seat validation uniqness
    put api_v1_ticket_path(id:5),params: { ticket: { email: 'adrian@gmail.com',
                                                     seat: 6,
                                                     show_time_id: 5 }}
    assert_equal JSON.parse(response.body)['seat'][0], "has already been taken"
  end
#-----------------------------------------------
  test "ShowTime Tickets dependent destroy" do
    get api_v1_tickets_path
    assert_equal JSON.parse(response.body).count, 5
    delete api_v1_show_time_path(id: 5)
    assert_response :success
    get api_v1_tickets_path
    assert_equal JSON.parse(response.body).count, 3
  end
#-----------------------------------------------
end