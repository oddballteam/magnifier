class Mutations::AddPersonalAccessToken < Mutations::BaseMutation
  null true
  argument :personal_access_token, String, required: true
  field :user, Types::UserType, null: true
  field :errors, [String], null: true
  def resolve(personal_access_token:)
    binding.pry
    ctx[:current_user].personal_access_token = personal_access_token
    if ctx[:current_user].save!
      {
        user: ctx[:current_user] ,
        errors: []
      }
    else
      {
        user: nil,
        errors:ctx[:current_user].errors.full_messages
      }

    end
  end
end