# blackjack-thrill
Game of blackjack

In order to get values of ActiveRecord object dynamically, we user "send"
e.g.
  a = ['first_name', 'last_name', 'email']
  u = User.find(1)
  u.send(a[2]) # will give the value of "email" attribute for User with id = 1

In order to set values of ActiveRecord object dynamically, we user "send" setter
e.g.
  a = ['first_name', 'last_name', 'email']
  u = User.find(1)
  u.send("#{a[2]}=", "b@b.com") # will set the value of "email" attribute for User with id = 1

Assignment to send rabl with various models and in random order:
  Create an object(@objects) in controller with all objects randomized but having an extra attribute called "object_type" saying what class the object belongs_to, which could be found from the objects while creating @objects.