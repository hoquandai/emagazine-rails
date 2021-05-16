json.(user, :id, :email, :name, :score)
json.token user.generate_jwt
