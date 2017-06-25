module Jekyll
  module ImageResizer
    class Command < Jekyll::Command
      def self.init_with_program(prog)
        prog.command(:resize) do |c|
          c.syntax "resize [options]"
          c.description 'Resize images'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            Resizer.process_images(args, options, opts)
            WaterMark.process_images(args, options, opts)
          end
        end

        prog.command(:watermark) do |c|
          c.syntax "watermark [options]"
          c.description 'Add watermark to images'

          c.action do |args, opts|
            opts['serving'] = false
            Jekyll.logger.adjust_verbosity(opts)
            options = configuration_from_options(opts)

            WaterMark.process_images(args, options, opts)
          end
        end
      end
    end
  end
end
