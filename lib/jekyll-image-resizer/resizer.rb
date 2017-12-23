module Jekyll
  module ImageResizer
    class Resizer
      attr_accessor :image_width, :image_small_height, :image_quality, :folder, :options, :args, :single_image

      def initialize(args, options)
        @options = options
        @args = args
        post = if args[0] && args[0].include?('.')
                 @single_image = args[0]
                 last_post
               elsif args[0] && !args[0].include?('.')
                 args[0]
               else
                 last_post
               end
        @image_width = options['image_width']
        @image_quality = args[1] ? args[1].to_i : options['image_quality']
        @image_small_height = args[2] ? args[2].to_i : options['image_small_height']
        @folder = Dir["**/"].select { |dir| dir.include?(post) }.reject { |dir| dir.include?('_site') }.first
      end

      def self.process_images(args, options)
        new(args, options).process
      end

      def process
        return puts("\nError! Can't find folder with this name.\n") if folder.nil?

        images = if single_image
                   image = "#{folder}#{single_image}"
                   return puts("\nError! There isn't image #{image}\n") unless File.exists?(image)

                   [image]
                 else
                   path = "#{folder}*.{jpg,png,gif,jpeg,JPG,JPEG}"
                   return puts("\nError! There are no images inside folder #{folder}\n") if Dir.glob(path).size.zero?

                   Dir.glob(path)
                 end

        puts "Folder: #{folder}"
        puts "Processing images with width: #{image_width}px(small width: #{image_small_height}px) and quality: #{image_quality}% \n\n"
        puts 'images:'

        images.each do |image|
          image_name = File.basename(image).downcase
          image_path = "#{folder}/#{image_name}"

          File.rename(image, image_path)
          next if image_name.include?('-small.') || image_name.include?('thumbnail')

          puts "  - #{image_name}"
          process_image(image_name, image_path)
        end

        puts "\nAll images in folder \"#{folder}\" were processed."
      end

      protected

      def last_post
        site = Jekyll::Site.new(options)
        site.reset
        site.read
        posts = site.posts.docs

        posts.last.data['slug']
      end

      def process_image(image_name, image_path)
        image = resize_image(image_path) do |image, ratio|
          height = if image.width > image.height
            image_width / ratio
          else
            image_width * ratio
          end.round

          [image_width, height]
        end
        image.write(image_path)

        image = resize_image(image_path) do |image, ratio|
          width = if image.width > image.height
            image_small_height * ratio
          else
            image_small_height / ratio
          end.round

          [width, image_small_height]
        end
        small_image_name = image_name.gsub!('.', '-small.')
        image.write("#{folder}/#{small_image_name}")
      end

      private

      def resize_image(image_path)
        image = MiniMagick::Image.open(image_path)
        image.quality(image_quality)
        ratio = image.width / image.height.to_f

        width, height = yield(image, ratio)

        image.resize "#{width}x#{height}"
        image
      end
    end
  end
end
