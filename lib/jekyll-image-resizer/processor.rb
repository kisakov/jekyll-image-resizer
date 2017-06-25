module Jekyll
  module ImageResizer
    class Processor < Resizer
      def process_image(image_name, image_path)
        super
        WaterMark.new(args, options).send(:process_image, image_name, image_path)
      end
    end
  end
end
