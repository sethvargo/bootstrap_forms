class Project < ActiveRecord::Base
  has_many :tasks
  accepts_nested_attributes_for :tasks
  validates :owner, :presence => true
  validates :if_presence, :presence => true, :if => lambda { true}
  validates :unless_presence, :presence => true, :unless => lambda { true}
  validates :create_presence, :presence => true, :on => :create
  validates :update_presence, :presence => true, :on => :update
  attr_accessor :if_presence, :unless_presence, :create_presence, :update_presence
  
end
