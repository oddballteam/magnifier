class CreateWeekInReviewAccomplishmentsComments < ActiveRecord::Migration[5.2]
  def change
    create_table :week_in_reviews do |t|
      t.date :start_date
      t.date :end_date
      t.references :user, foreign_key: true
      t.timestamps
    end

    create_table :accomplishments do |t|
      t.belongs_to :week_in_review, index: true
      t.belongs_to :statistic, index: true
      t.string :type
      t.integer :action
      t.references :user, foreign_key: true
      t.timestamps
    end

    create_table :comments do |t|
      t.references :week_in_review, foreign_key: true
      t.text :body
      t.integer :type
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
