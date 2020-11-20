module Jekyll
  module ImageResizer
    class Command < Jekyll::Command
      def self.init_with_program(prog)
        prog.command(:image) do |c|
          c.alias(:photo)
          c.syntax "image [options]"
          c.description 'Resize and watermark images'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            Processor.process_images(args, options)
          end
        end

        prog.command(:images) do |c|
          c.syntax "images [options]"
          c.description 'Print image names'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            Resizer.print_images(args, options)
          end
        end

        prog.command(:resize) do |c|
          c.syntax "resize [options]"
          c.description 'Resize images'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            Resizer.process_images(args, options)
          end
        end

        prog.command(:watermark) do |c|
          c.syntax "watermark [options]"
          c.description 'Add watermark to images'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            WaterMark.process_images(args, options)
          end
        end

        prog.command(:thumbnail) do |c|
          c.syntax "thumbnail [options]"
          c.description 'Create thumbnail from image'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            Thumbnail.process_images(args, options)
          end
        end
      end
    end
  end
end
