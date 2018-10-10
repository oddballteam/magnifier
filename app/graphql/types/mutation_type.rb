module Types
  class MutationType < Types::BaseObject
    field :add_personal_access_token, mutation: Mutations::AddPersonalAccessToken
  end
end
