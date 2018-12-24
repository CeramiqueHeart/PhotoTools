require 'exifr/jpeg'
require 'streamio-ffmpeg'

file_type = ["jpg", "jpeg", "mov", "mp4"]
file_list = Array.new
file_data = Hash.new
db_file   = "photoscan.db"

file_type.map! do |item|
  item = "**/*." + item
end

if (File.exist? db_file)
  File.open(db_file, "rb") do |file|
    file_list, file_data = Marshal.load(file)
  end
end

Dir.chdir(ARGV[0]) do
  Dir.glob(file_type, File::FNM_CASEFOLD) do |file|
    unless file_list.include? file
      puts file
      file_list.push file
      unless file_data.has_key?(File.basename(file))
          file_data[File.basename(file)] = Array.new
      end
      if File.extname(file).downcase == '.jpg' or
        File.extname(file).downcase == '.jpeg'
        file_data[File.basename(file)].push(EXIFR::JPEG.new(file).date_time_original)
      else
        file_data[File.basename(file)].push(FFMPEG::Movie.new(file).creation_time)
      end
    end
  end
end

File.open(db_file, "wb") do |file|
    Marshal.dump([file_list, file_data], file)
end
