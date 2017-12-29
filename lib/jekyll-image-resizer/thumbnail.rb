module Jekyll
  module ImageResizer
    class Thumbnail < Resizer
      attr_accessor :thumbnail_width

      def initialize(args, options)
        super
        @thumbnail_width = options['thumbnail_width']
      end

      def process_image(image_name, image_path)
        image = resize_image(image_path) do |image, ratio|
          height = if image.width > image.height
                     thumbnail_width / ratio
                   else
                     thumbnail_width * ratio
                   end.round

          [thumbnail_width, height]
        end

        thumbnail_image_name = image_name.prepend('thumbnail-')
        image.write("#{folder}/#{thumbnail_image_name}")
      end
    end
  end
end
