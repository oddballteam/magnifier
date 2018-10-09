module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
                               description: "An example field added by the generator",
                               resolve: ->(obj, args, ctx) {
                                          "#{args[:tester]} sales is dope"
                                        } do
      argument :tester, String, "testerdoo", required: true
    end

    field :users, [Types::UserType], null: true,
                                     description: "Load all users",
                                     resolve: ->(obj, args, ctx) { User.all }
    field :me, Types::UserType, null: true,
                                description: "Load me",
                                resolve: ->(obj, args, ctx) { ctx[:current_user] }
  end
end
