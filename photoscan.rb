require 'exifr/jpeg'
require 'streamio-ffmpeg'

file_type = ["jpg", "jpeg", "mov", "mp4"]
data      = Hash.new

file_type.map! do |item|
  item = "**/*." + item
end

Dir.chdir(ARGV[0]) do
  Dir.glob(file_type, File::FNM_CASEFOLD) do |file|
    puts file
    unless data.has_key?(File.basename(file))
        data[File.basename(file)] = Array.new
    end
    if File.extname(file).downcase == '.jpg' or
       File.extname(file).downcase == '.jpeg'
      data[File.basename(file)].push(EXIFR::JPEG.new(file).date_time_original)
    else
      data[File.basename(file)].push(FFMPEG::Movie.new(file).creation_time)
    end
  end
end

File.open("photoscan.db", "wb") do |file|
    Marshal.dump(data, file)
end
