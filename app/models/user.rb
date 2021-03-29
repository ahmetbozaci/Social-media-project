class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :friend_id, dependent: :destroy

  has_many :accepted_friendships, -> { where(status: true) }, class_name: 'Friendship'
  has_many :pending_friendships, -> { where(status: false) }, class_name: 'Friendship', foreign_key: :friend_id

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.status == true }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.status }
    friends_array.compact
  end

  # Users who have yet to confirmed friend requests
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.status }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.status }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friend| friend.user == user }
    frienship.status = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

    def mutual_friend(user_1, user_2)
    @mutual_friend = []
    user_1.friends.each do |f|
      user_2.friends.each do |g|
        if f.id = g.id 
          @mutual_friend << g.name
        end
      end
    end
    @mutual_friend.uniq
    @mutual_friend.delete(user_1.name)
    @mutual_friend
  end
end
