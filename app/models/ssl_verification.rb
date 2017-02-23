# == Schema Information
#
# Table name: ssl_verifications
#
#  id         :integer          not null, primary key
#  key        :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SslVerification < ActiveRecord::Base
end
