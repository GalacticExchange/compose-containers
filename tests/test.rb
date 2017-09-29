str = "2017-07-31 11:32:48.145408 container attach 92385e8a66afbe162dc5d856d91cd75d10b71971e4710d40e11406ebc4f5f872 (image=redis, name=compose_redis_1)"


json = {
      "service": "phpmyadmin",
      "time": "2017-07-31T11:35:51.928656",
      "action": "kill",
      "attributes": {"image": "corbinu/docker-phpmyadmin", "name": "compose_phpmyadmin_1"},
      "type": "container",
      "id": "f8531080e43db78546fbcec0359d3747c4262956fbce192a3dd4d2fbdbc70106"
    }

arr = str.split(' ')

arr.each do |w|
  p w
end