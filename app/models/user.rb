class User < ApplicationRecord
    validates :name, {presence: true}
    # validates :email, {uniqueness: true, presence: true}
    validates :password, {presence: true}
    has_many :answers

    def self.find_or_create_from_auth(auth)
        puts auth
        provider = auth[:provider]
        uid = auth[:uid]
        nickname = auth[:info][:nickname]
        # email = User.dummy_email(auth)
        password = User.dummy_password()

        self.find_or_create_by(provider: provider, uid: uid) do |user|
            user.name = nickname
            # user.email = email
            user.password = password
        end
    end

    private
    def self.dummy_email(auth)
        "#{auth.uid}-#{auth.provider}@example.com"
    end

    def self.dummy_password()
        a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['~','!','@','#','$','%','^','&','*','(',')','-','+']
        pass = Array.new(16){a[rand(a.size)]}.join
        pass
    end
end
