require 'rails_helper'

describe InvitationLink do
  let(:team) { create :team }
  let(:user) { create :user }

  it 'is expired after the period of validity' do
    invitation_link = create :invitation_link, team: team, inviting_user: user, created_at: Time.current - 3.days

    invitation_link.should be_expired
  end

  it 'is not expired during the period of validity' do
    invitation_link = create :invitation_link, team: team, inviting_user: user, created_at: Time.current - 2.days

    invitation_link.should_not be_expired
  end

  it 'does not count expired links as active' do
    invitation_link = create :invitation_link, team: team, inviting_user: user, created_at: Time.current - 3.days

    invitation_link.should_not be_active
  end

  it 'does not count used links as active' do
    invitation_link = create :invitation_link, team: team, inviting_user: user, created_at: 10.minutes.ago, used_at: Time.current

    invitation_link.should_not be_active
  end

  it 'counts non used and valid links as active' do
    invitation_link = create :invitation_link, team: team, inviting_user: user

    invitation_link.should be_active
  end
end
