json.(user, :id, :email, :name, :score)
json.token user.generate_jwt
json.avatar user.avatar_path
