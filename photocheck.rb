require 'fileutils'
require 'exifr/jpeg'
require 'streamio-ffmpeg'

file_type    = ["jpg", "jpeg", "mov", "mp4"]
exist_folder = "exists"
exist_files  = Array.new

file_type.map! do |item|
  item = "**/*." + item
end

data = nil
File.open("photoscan.db", "rb") do |file|
  data = Marshal.load(file)
end

Dir.chdir(ARGV[0]) do
  Dir.glob(file_type, File::FNM_CASEFOLD).sort.each do |file|
    if data.has_key?(File.basename(file))
      if File.extname(file).downcase == '.jpg' or
         File.extname(file).downcase == '.jpeg'
        unless data[File.basename(file)].index(EXIFR::JPEG.new(file).date_time_original)
          puts file + ': ' + 'not found'
        else
          exist_files.push(file)
        end
      else
        unless data[File.basename(file)].index(FFMPEG::Movie.new(file).creation_time)
          puts file + ': ' + 'not found'
        else
          exist_files.push(file)
        end
      end
    else
      puts file + ': ' + 'not found'
    end
  end

  puts "Moving existing files to '#{exist_folder}'"
  unless Dir.exists?(exist_folder) then
    Dir.mkdir(exist_folder)
  end
  FileUtils.mv(exist_files, exist_folder)
end

