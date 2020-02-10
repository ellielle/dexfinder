# Create main User account for testing, along with 6 random Users
User.create(username: "Buttstuff", email: "test@test.com", password: "testing")
12.times do |n|
  User.create(username: Faker::Internet.username, email: "test#{n}@test.com",
              password: "testing")
end

# Create a set of FriendRequests for main User, and a few for other Users for testing
7.times do |n|
  User.first.outgoing_friend_requests.create(to_user_id: n) unless n == User.first.id
end

# Have every user send User 3 a FriendRequest, except the first
User.all.each do |user|
  if (user.id != User.first.id) && (user.id != 3)
    user.outgoing_friend_requests.create(to_user_id: 3)
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
@comment_count = 0

Post.all.each do |post|
  5.times do
    Comment.create(body: Faker::Books::Lovecraft.sentence, user_id: rand(1..7),
                   commentable_type: "Post", commentable_id: post.id)
  end
end

Comment.all.each do |comment|
  rand(1..2).times do
    Comment.create(body: Faker::Books::Lovecraft.sentence, user_id: rand(1..7),
                   commentable_type: "Comment", commentable_id: comment.id)
    @comment_count += 1
  end
end

Comment.all.each do |comment|
  if comment.commentable_type == "Comment" && @comment_count <= 500
    rand(1..3).times do
      Comment.create(body: Faker::Books::Lovecraft.sentence, user_id: rand(1..7),
                     commentable_type: "Comment", commentable_id: comment.id)
      @comment_count += 1
    end
  elsif @comment_count > 500
    break
  end
end

# Create a random number of Likes for each Post within the constraints of number of Users
Post.all.each do |post|
  rand(1..6).times do |n|
    post.likes.create(post_id: post.id, user_id: n)
  end
end