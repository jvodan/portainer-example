require 'rubygems'
require './http/requests'


def user_creds 
{  'password' => 'mypassword',
  'username' =>  'admin'}
end

host = '192.168.20.51'
port = 9000
@site = "http://#{host}:#{port}/"

def auth_token
  @auth_token ||= authenticate(user_creds)
end


def list_endpoints
 get('api/endpoints')
end

def list_docker_containers(end_point_id=1)
 get("/api/endpoints/#{end_point_id}/docker/containers/json")
end

def get_docker_container(container_id,end_point_id=1)
 get("/api/endpoints/#{end_point_id}/docker/containers/#{container_id}/json")
end

def docker_start_container(container_id,end_point_id=1)
 post("/api/endpoints/#{end_point_id}/docker/containers/#{container_id}/start", nil)
end

def docker_stop_container(container_id,end_point_id=1)
 post("/api/endpoints/#{end_point_id}/docker/containers/#{container_id}/stop", nil)
end

def docker_remove_container(container_id,end_point_id=1)
 delete("/api/endpoints/#{end_point_id}/docker/containers/#{container_id}", nil)
end

def list_docker_images(end_point_id=1)
 get("/api/endpoints/#{end_point_id}/docker/images/json")
end

def get_docker_image(image_id,end_point_id=1)
 get("/api/endpoints/#{end_point_id}/docker/images/#{image_id}/json")
end



auth_token
#warn list_endpoints.to_s
#warn list_docker_containers.to_s
#warn list_docker_images.to_s
#warn get_docker_container('f2d1f257ce02273bb4ec1f7bbf2a39d4bc13b55a19bd0d4a3eb00e53c21117bb').to_s
#warn get_docker_image('sha256:c8a841fa5a8475f0ad5e12d31678950fc9c66a978ff45314102b118e516cf9c3').to_s
#warn docker_start_container('f2d1f257ce02273bb4ec1f7bbf2a39d4bc13b55a19bd0d4a3eb00e53c21117bb').to_s
#warn docker_stop_container('f2d1f257ce02273bb4ec1f7bbf2a39d4bc13b55a19bd0d4a3eb00e53c21117bb').to_s
#warn docker_remove_container('f2d1f257ce02273bb4ec1f7bbf2a39d4bc13b55a19bd0d4a3eb00e53c21117bb').to_s

