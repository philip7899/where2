class Place < ActiveRecord::Base
	mount_uploader :picture, PictureUploader
end
