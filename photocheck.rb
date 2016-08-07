require 'exifr'

file_type = ["jpg", "jpeg", "mov", "mp4"]

file_type.map! do |item|
  item = "**/*." + item
end

data = nil
File.open("photoscan.db", "rb") do |file|
  data = Marshal.load(file)
end

Dir.chdir(ARGV[0]) do
  Dir.glob(file_type, File::FNM_CASEFOLD) do |file|
    if data.has_key?(File.basename(file))
      if File.extname(file).downcase == '.jpg' or
         File.extname(file).downcase == '.jpeg'
        unless data[File.basename(file)].index(EXIFR::JPEG.new(file).date_time_original)
          puts file + ': ' + 'not found'
        end
      else
        unless data[File.basename(file)].index(File.mtime(file))
          puts file + ': ' + 'not found'
        end
      end
    else
      puts file + ': ' + 'not found'
    end
  end
end
