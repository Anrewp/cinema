require 'test_helper'

class AuditoriaControllerTest < ActionDispatch::IntegrationTest
#------------------------------------------------
  test "GET AUDITORIA" do
#1.show auditoria
    get api_v1_auditoria_path
    assert_response :success

#2.show auditorium by id    
    get api_v1_auditorium_path(id: 5)
    assert_response :success

#3.id not found   
    get api_v1_auditorium_path(id: 1)
    assert_response :not_found

#4.show auditorium by title    
    get title_api_v1_auditoria_path(title: 'Monro')
    assert_response :success

#5.title not found
    get title_api_v1_auditoria_path(title: 'No Auditoria')
    assert_response :not_found
  end
#----------------------------------------------  
  test "POST AUDITORIA" do
#1.create auditorium 
  	post api_v1_auditoria_path, params: { auditorium: { title: 'New Auditorium', capacity: 40 }}
  	assert_response :success

#2.title validation uniqueness 
  	post api_v1_auditoria_path, params: { auditorium: { title: 'New Auditorium', capacity: 40 }}
    assert_equal JSON.parse(response.body)['title'][0], "has already been taken"

#3.title validation presence
    post api_v1_auditoria_path, params: { auditorium: { title: '', capacity: 40 }}
    assert_equal JSON.parse(response.body)['title'][0], "can't be blank"

#4.capacity validation presence
    post api_v1_auditoria_path, params: { auditorium: { title: 'New Auditorium2' }}
    assert_equal JSON.parse(response.body)['capacity'][0], "can't be blank"    

#5.capacity validation range 
    post api_v1_auditoria_path, params: { auditorium: { title: 'New Auditorium2', capacity: 0 }}
    assert_equal JSON.parse(response.body)['capacity'][0], "Capacity can't be 0 or negetive number"    
  end
#------------------------------------------------
  test "DELETE AUDITORIA" do
#1.delete auditorium
    delete api_v1_auditorium_path(id: 5)
    assert_response :success

#2.auditorium not found 
    delete api_v1_auditorium_path(id:234)
    assert_response :not_found
  end
#-----------------------------------------------
  test "PUT AUDITORIA" do
#1.edit auditorium
    put api_v1_auditorium_path(id:5),params: { auditorium: { title: 'Bob 13', capacity: 10 }}
    assert_response :success

#2.title validation uniqueness
    put api_v1_auditorium_path(id:5),params: { auditorium: { title: 'Chaplin', capacity: 10 }}
    assert_equal JSON.parse(response.body)['title'][0], "has already been taken"

#3.auditorium not found
    put api_v1_auditorium_path(id:1),params: { auditorium: { title: 'Bob 13', capacity: 10 }}
    assert_response :not_found

#4.title validation presence
    put api_v1_auditorium_path(id:5),params: { auditorium: { title: '', capacity: 10 }}
    assert_equal JSON.parse(response.body)['title'][0], "can't be blank"

#5.capacity validation range 
    put api_v1_auditorium_path(id:5), params: { auditorium: { title: 'New Auditorium2', capacity: 0 }}
    assert_equal JSON.parse(response.body)['capacity'][0], "Capacity can't be 0 or negetive number"    
  end  
#-----------------------------------------------
test "Auditorium -> ShowTime -> Tickets dependent destroy" do
    get api_v1_tickets_path
    assert_equal JSON.parse(response.body).count, 5
    get api_v1_show_times_path
    assert_equal JSON.parse(response.body).count, 4
    delete api_v1_auditorium_path(id: 5)
    assert_response :success
    get api_v1_show_times_path
    assert_equal JSON.parse(response.body).count, 0
    get api_v1_tickets_path
    assert_equal JSON.parse(response.body).count, 0
  end
#-----------------------------------------------
end