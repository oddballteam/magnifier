require 'rails_helper'

RSpec.describe do
  it "has an up to date .graphql file" do
    current_defn = MagnifierSchema.to_definition
    printout_defn = File.read(Rails.root.join("app/graphql/schema.graphql"))
    expect(current_defn).to eq(printout_defn), "Update the printed schema with `bundle exec rake graphql:dump_schema`"
  end
end
