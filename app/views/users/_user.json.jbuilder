json.(user, :id, :email, :name, :score, :is_admin)
json.token user.generate_jwt
json.avatar user.avatar_path
