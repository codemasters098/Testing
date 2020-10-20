require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Report and<br>Content Videos<br>(valued at $47)',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'assets/home/GIFT10.png')
    },
    {
      'count' => 20,
      'html' => 'First Home<br>Strategy Call<br>(valued at $247)',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/home/G25-6038337b88355a6ae44b540a9ff735b11b0f2dbf5705e1a02a52459c0d73fb68.PNG')
    },
    {
      'count' => 50,
      'html' => 'First Home<br>Buyer Mastery<br>(valued at $997)',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/home/GIFT50-21c3caca93e437857cef39a6950fcbf8407fc058acde026ab26d3ecbd768decb.png')
    },
    {
      'count' => 100,
      'html' => '1-on-1 Property<br>Mentorship<br>(valued at $4997)',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/home/GIFT100.png')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
