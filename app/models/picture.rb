class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  # attr_accessible :caption, :description

  has_attached_file :asset, styles: {
    large: "800x800>",medium: "300x200>", small: "260x180>", thumb: "80x80#"
  } # the geometry strings and the sufix symbol come from image_magick pluggin documentation
    # These sizes are aligned with Bootstrap size standards

  validates_attachment_content_type :asset, :content_type => %w(image/jpeg image/jpg image/png image/gif)
end
