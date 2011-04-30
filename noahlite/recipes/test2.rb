noahlite_application "my_funky_fresh_app" do 
  noah_server "localhost"
  noah_port   "5678"
  on_failure  :pass
  action [:create]
end
