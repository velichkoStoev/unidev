class Message < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  validates :title, presence: true
  validates :body, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def date_created
    created_at.strftime('%H:%M, %d.%b.%Y ')
  end
end
