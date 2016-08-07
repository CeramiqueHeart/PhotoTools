require 'exifr'

tgt_dir = File.expand_path(ARGV[0])

data = nil
File.open("photoscan.db", "rb") do |file|
    data = Marshal.load(file)
end

Dir::glob(tgt_dir + '/**/*.JPG').each do |file|
    if data.has_key?(File.basename(file)) and
        data[File.basename(file)].index(EXIFR::JPEG.new(file).date_time_original)
        # puts file + ': ' + 'found'
    else
        puts file + ': ' + 'not found'
    end
end

Dir::glob(tgt_dir + '/**/*.MOV').each do |file|
    if data.has_key?(File.basename(file)) and
        data[File.basename(file)].index(File.mtime(file))
        # puts file + ': ' + 'found'
    else
        puts file + ': ' + 'not found'
    end
end
