class User < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy
  has_many :groups, dependent: :destroy

  has_many :joins, dependent: :destroy
  has_many :join_groups, through: :joins, source: :group
  has_many :reads, dependent: :destroy
  has_many :read_tasks, through: :reads, source: :task

  before_update :admin_check_existence_update
  before_destroy :admin_check_existence_destroy

  validates :name, presence: true, length: { maximum: 50 }

  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 500 }, uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  private

  def admin_check_existence_update
    # 変更後の自身(self)のインスタンスのadminの値はfalseになるが、DBに登録されている自身のadminの値はtrueの場合（自身をadminで無くそうとしている場合）条件を満たす
    raise "application_without_administrator" if (self.admin == false && User.where(admin: true).count == 1) && self == User.find_by(admin: true)
  end

  def admin_check_existence_destroy
    raise "application_without_administrator" if self.admin == true && User.where(admin: true).count == 1
  end
end
