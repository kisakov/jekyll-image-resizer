module Jekyll
  module ImageResizer
    class Command < Jekyll::Command

      class << self
        attr_accessor :image_width, :image_small_width, :image_quality, :folder

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

          post = args[0]
          @image_width = options['image_width']
          @image_small_width = args[1] ? args[1].to_i : options['image_small_width']
          @image_quality = args[2] ? args[2].to_i : options['image_quality']
          @folder = "assets/images/posts/#{post}"
          path = "#{folder}/*.{jpg,png,gif,jpeg,JPG,JPEG}"

          puts "Processing images with width: #{image_width}px(small width: #{image_small_width}px) and quality: #{image_quality}% \n\n"
          puts 'images:'

          Dir.glob(path) do |image_path|
            image_name = File.basename(image_path)
            next if image_name.include?('-small.')

            process_image(image_name, image_path)
          end

          puts "\nAll images in folder \"#{folder}\" were processed."
        end

        def process_image(image_name, image_path)
          puts "  - #{image_name}"

          image = resize_image(image_path, image_width)
          image.write(image_path)

          image = resize_image(image_path, image_small_width)
          small_image_name = image_name.gsub!('.', '-small.')
          image.write("#{folder}/#{small_image_name}")
        end

        def resize_image(image_path, width)
          image = MiniMagick::Image.open(image_path)
          image.quality(image_quality)
          ratio = image.width / image.height.to_f

          if image.width > image.height
            height = (width / ratio).round
            width = width
          else
            height = (width * ratio).round
            width = (height * ratio).round
          end

          image.resize "#{width}x#{height}"
          image
        end
      end

    end
  end
end
