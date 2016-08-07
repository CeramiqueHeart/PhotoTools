require 'exifr'

src_dir = File.expand_path(ARGV[0])
data = Hash.new

Dir::glob(src_dir + '/**/*.JPG').each do |file|
    puts file
    unless data.has_key?(File.basename(file))
        data[File.basename(file)] = Array.new
    end
    data[File.basename(file)].push(EXIFR::JPEG.new(file).date_time_original)
end

Dir::glob(src_dir + '/**/*.MOV').each do |file|
    puts file
    unless data.has_key?(File.basename(file))
        data[File.basename(file)] = Array.new
    end
    data[File.basename(file)].push(File.mtime(file))
end

File.open("photoscan.db", "wb") do |file|
    Marshal.dump(data, file)
end
