require 'rails_helper'

RSpec.describe do
  it "has an up to date .graphql file" do
    current_defn = MagnifierSchema.to_definition
    printout_defn = File.read(Rails.root.join("app/graphql/schema.graphql"))
    assert_equal(current_defn, printout_defn, "Update the printed schema with `bundle exec rake dump_schema`")
  end
end