class Contact < ActiveRecord::Base
  has_and_belongs_to_many :user, -> { uniq }
  has_many :notes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #after_create :notify_by_email
  rails_admin do
   list do
       field :first_name
       field :last_name
       field :email
       field :function
   end
   edit do
       field :first_name
       field :last_name
       field :email
       field :phone
       field :users
       field :password
       field :password_confirmation
   end

   show do
       field :first_name
       field :last_name
       field :email
       field :function
       field :users
        

   end
 end



  def generate_password
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    self.password = (0...8).map { o[rand(o.length)] }.join
    self.notify_by_email(self.password)
  end

  def notify_by_email(password)
    ContactMailer.new_register(self, password).deliver_now
  end
end