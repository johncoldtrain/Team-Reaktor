class Document < ActiveRecord::Base

	has_attached_file :attachment, styles: {
    large: "800x800>", medium: "300x200>", small: "260x180>", thumb: "80x80#"
  } # the geometry strings and the sufix symbol come from image_magick pluggin documentation
    # These sizes are aligned with Bootstrap size standards

	validates_attachment_content_type :attachment, :content_type => %w(image/jpeg image/jpg image/png image/gif)

	attr_accessor :remove_attachment

	
	before_save :perform_attachment_removal

	def perform_attachment_removal
		if remove_attachment == '1' && !attachment.dirty?
			self.attachment = nil
		end
	end

end
