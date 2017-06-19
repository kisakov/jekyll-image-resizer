module Jekyll
  module ImageResizer
    class Command < Jekyll::Command

      class << self
        attr_accessor :image_width, :image_small_height, :image_quality, :folder

        def init_with_program(prog)
          prog.command(:resize) do |c|
            c.syntax "resize [options]"
            c.description 'Resize images'

            c.action do |args, opts|
              opts['serving'] = false
              Jekyll.logger.adjust_verbosity(opts)
              process_images(args, opts)
            end
          end
        end

        def process_images(args, opts)
          options = configuration_from_options(opts)

          post = args[0] || last_post(opts)
          @image_width = options['image_width']
          @image_small_height = args[1] ? args[1].to_i : options['image_small_height']
          @image_quality = args[2] ? args[2].to_i : options['image_quality']
          @folder = Dir["**/"].select { |dir| dir.include?(post) }.reject { |dir| dir.include?('_site') }.first

          return puts("\nError! Can't find folder with this name.\n") if folder.nil?

          path = "#{folder}/*.{jpg,png,gif,jpeg,JPG,JPEG}"

          return puts("\nError! There are no images inside folder #{folder}\n") if Dir.glob(path).size.zero?

          puts "Processing images with width: #{image_width}px(small width: #{image_small_height}px) and quality: #{image_quality}% \n\n"
          puts 'images:'

          Dir.glob(path) do |image_path|
            image_name = File.basename(image_path)
            next if image_name.include?('-small.')

            process_image(image_name, image_path)
          end

          puts "\nAll images in folder \"#{folder}\" were processed."
        end

        def last_post(opts)
          options = configuration_from_options(opts)
          site = Jekyll::Site.new(options)
          site.reset
          site.read
          posts = site.posts.docs

          posts.last.data['slug']
        end

        def process_image(image_name, image_path)
          puts "  - #{image_name}"

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
end
