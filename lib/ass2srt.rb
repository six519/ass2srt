def desc_to_tag(description, txt)

    case 
        when description == "Bold"
            "<b>" << txt << "</b>"
        when description == "Italic"
            "<i>" << txt << "</i>"
        else
            txt
    end

end

def dec_to_int(tm)
    splitted_time = tm.split(/\./)
    int_mill = (("0." << splitted_time[1]).to_f * 1000).to_i
    splitted_time[0] << "," << int_mill.to_s
end

def ass_to_srt(fname)
    begin

        splitted_filename = fname.split(/\./)
        line_counter = 2

        if splitted_filename.length < 2
            raise "Invalid filename - " << fname
        end

        if splitted_filename[1] != "ass"
            raise "Invalid file extension - " << splitted_filename[1]
        end

        ass_file = File.open(fname, 'r') do |f|
            srt_file = File.open(splitted_filename[0] << ".srt", "w") do |f2|

                f2.puts "1\n00:00:01,100 --> 00:00:10,100\n<b>Ass File to Srt By: Ferdinand Silva</b>\n\n"

                while ln = f.gets
                    #write to srt file

                    splitted_line = ln.split(/,/)
                    if splitted_line.length > 8
                        if splitted_line[0] =~ /Dialogue/i
                            #Write line #
                            f2.puts line_counter
                            #Write time
                            f2.puts dec_to_int(splitted_line[1]) << " --> " << dec_to_int(splitted_line[2]) << "\n" << desc_to_tag(splitted_line[3], splitted_line[9])
                            #Write linebreak
                            f2.puts "\n"

                            #increment counter
                            line_counter += 1
                        end
                    end
                end
            end
        end

        puts "\n" << splitted_filename[0] << " file generated!!!\n"
    rescue => exc
        puts "An error occurred while opening the file " << fname << ". The error is: " << exc.message << "."
    end
end