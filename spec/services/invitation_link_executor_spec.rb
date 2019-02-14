require 'rails_helper'

describe InvitationLinkExecutor do
  let(:user) { create :user }
  let(:company) { create :company }
  let(:invitation_link) { create :invitation_link, company: company }

  around do |example|
    Timecop.freeze { example.run }
  end

  it 'adds user to a company' do
    InvitationLinkExecutor.execute invitation_link, user

    company.employees.should eq [user]
  end

  it 'marks the invitation link as used' do
    expect do
      InvitationLinkExecutor.execute invitation_link, user
    end.to change(invitation_link, :used_at).from(nil).to(Time.current)
  end

  it 'records the invited user in the invitation' do
    expect do
      InvitationLinkExecutor.execute invitation_link, user
    end.to change(invitation_link, :invited_user).from(nil).to(user)
  end

  it 'abadons user company if he belongs to one and accept the invitation' do
    existing_company = create :company, name: 'Existing Inc'
    invitation_company = create :company, name: 'Invitation Inc'
    invitation_link = create :invitation_link, company: invitation_company

    user = create :user, company: existing_company

    expect do
      InvitationLinkExecutor.execute invitation_link, user
    end.to change { user.company }.from(existing_company).to(invitation_company)
  end
end
