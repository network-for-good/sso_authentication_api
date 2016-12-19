class Admin < ActiveRecord::Base
  # used to replicate an active record object
  def self.where(options)
    []
  end

  def valid_password?(password)
    true
  end

  def first_name
    "John"
  end

  def last_name
    "Smith"
  end

  def email
    "this@that.com"
  end

  def status
    "active"
  end

  def roles
    ["owner"]
  end
end