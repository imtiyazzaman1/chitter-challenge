require 'user'

describe User do
  describe '#initialize' do
    subject { described_class.new(id: '1', name: 'Ash Ketchum',
      username: '@red', email: 'ash@pallet.com')
    }
    it "has an id" do
      expect(subject.id).to eq '1'
    end

    it "has a name" do
      expect(subject.name).to eq 'Ash Ketchum'
    end

    it "has a username" do
      expect(subject.username).to eq '@red'
    end

    it "has an email" do
      expect(subject.email).to eq 'ash@pallet.com'
    end
  end

  describe '.create' do
    it "should add a new user to the db" do
      user = User.create(name: 'Gary Oak', username: 'blue',
        email: 'gary@pallet.com', password: 'eevee123'
      )
      expect(user.name).to eq 'Gary Oak'
      expect(user.username).to eq '@blue'
      expect(user.email).to eq 'gary@pallet.com'
    end

    it "encrypts the password" do
      expect(BCrypt::Password).to receive(:create).with('eevee123')

      User.create(name: 'Gary Oak', username: 'blue', email: 'gary@pallet.com',
        password: 'eevee123')
    end
  end

  describe '.username_in_db?' do
    it "returns true if user is already in db" do
      add_user_to_db
      expect(User.username_in_db?('@red')).to eq true
    end

    it "returns false if user is not already in db" do
      expect(User.username_in_db?('@red')).to eq false
    end
  end

  describe '.email_in_db?' do
    it "returns true if email is already in db" do
      add_user_to_db
      expect(User.email_in_db?('ash@pallet.com')).to eq true
    end

    it "returns false if email is not already in db" do
      expect(User.email_in_db?('ash@pallet.com')).to eq false
    end
  end

  describe '.authenticate' do
    before(:each) do
      @user = User.create(name: 'Professor Oak', username: '@p_oak',
        email: 'p_oak@pallet.com', password: 'pokedex123'
      )
    end

    it "returns a user when given corrent login info" do
      authenticated_user = User.authenticate(email: 'p_oak@pallet.com',
        password: 'pokedex123'
      )
      expect(authenticated_user.id).to eq @user.id
    end

    it "returns nil if the email address is incorrect" do
      authenticated_user = User.authenticate(email: 'poak@pallet.com',
        password: 'pokedex123'
      )
      expect(authenticated_user).to be_nil
    end

    it "returns nil if the password is incorrect" do
      authenticated_user = User.authenticate(email: 'p_oak@pallet.com',
        password: 'pokedex'
      )
      expect(authenticated_user).to be_nil
    end

  end
end
