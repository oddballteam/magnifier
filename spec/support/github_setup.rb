def setup_github_org_and_user
  let(:datetime) { '2018-09-01T20:43:46Z' }
  let(:personal_access_token) { SecureRandom.hex(16) }
  let(:org_name) { 'department-of-veterans-affairs' }
  let(:org) { create :organization, name: org_name }
  let(:github_username) { 'hpjaj' }
  let(:user) do
    create(
      :user,
      github_username: github_username,
      organization_id: org.id,
      personal_access_token: personal_access_token
    )
  end
end
