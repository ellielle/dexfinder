# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create main User account for testing, along with 6 random Users
User.create(username: "Buttstuff", email: "test@test.com", password: "testing")
6.times do |n|
  User.create(username: Faker::Internet.username, email: "test#{n}@test.com",
              password: "testing")
end

# Create a set of FriendRequests for each User, using count - 1 to avoid potential issues
User.all.each do |user|
  (User.count - 1).times do |n|
    user.outgoing_friend_requests.create(to_user_id: n) unless n == user.id
  end
end

# Create a bunch of Posts, some with main test account (User id 1), the rest with randoms
30.times do |n|
  if n % 2 == 0
    Post.create(title: Faker::Cannabis.strain, body: Faker::Books::Lovecraft.paragraph,
                user_id: rand(2..7))
  else
    Post.create(title: Faker::Cannabis.strain, body: Faker::Books::Lovecraft.paragraph,
                user_id: 1)
  end
end

# Create top level and child Comments for each Post
Post.all.each do |post|
  5.times do
    Comment.create(body: Faker::Books::Lovecraft.sentence, user_id: rand(1..7),
                   commentable_type: "Post", commentable_id: post.id)
  end

end

# Create a random number of Likes for each Post within the constraints of number of Users
Post.all.each do |post|
  rand(1..6).times do |n|
    post.likes.create(post_id: post.id, user_id: n)
  end
end