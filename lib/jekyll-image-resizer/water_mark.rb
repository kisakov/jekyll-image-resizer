module Jekyll
  module ImageResizer
    class WaterMark < Resizer
      def process_image(image_name, image_path)
        watermark = options['watermark'] || 'assets/images/watermark_karmelalla.png'
        image = MiniMagick::Image.open(image_path)

        image.combine_options do |c|
          c.gravity 'SouthEast'
          c.draw "image Over 0,0 0,0 '#{watermark}'"
        end

        image.write(image_path)
      end
    end
  end
end
