class Document < ActiveRecord::Base

	has_attached_file :attachment
	validates_attachment_content_type :attachment, :content_type => %w(image/jpeg image/jpg image/png image/gif)

	attr_accessor :remove_attachment

	
	before_save :perform_attachment_removal

	def perform_attachment_removal
		if remove_attachment == '1' && !attachment.dirty?
			self.attachment = nil
		end
	end

end
