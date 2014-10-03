class App
    def initialize(arguments,stdin)
        @arguments = arguments
        @stdin = stdin
        @outFile = File.open("index.html", "w")    
        @fileCounter = 0
        @inContents = false

    end

    def run
        @f1 = File.open(@arguments[0], "r")
        readFile(@f1)
        @f1.close
        @outFile.close
        puts ""
        puts "Done: all files expanded to index.html."
    end 

    def readFile(f)
        f.each_line do |line|
            copyLine = line.lstrip
            if (copyLine.start_with?('//copy')) 
                next
            end
            if ( copyLine.start_with?('/copy')) 
                copyFile = copyLine[6..-1].strip
                @outFile.write "<!-- Begin: #{copyFile} -->\n"
                puts "Including: " + copyFile
                f2 = File.open(copyFile, "r")
                self.readSubFile(f2)
                f2.close         
                @outFile.write "<!-- End: #{copyFile} -->\n"
            else 
                @outFile.write line
            end
        end
    end

    def readSubFile(f)
        inContents = false
        f.each_line do |line|
            copyLine = line.lstrip

            next if (copyLine.start_with?('//copy')) 

            break if copyLine.start_with?('<!-- Content ends here -->')  

            if copyLine.start_with?('<!-- Content starts here -->')  
               inContents = true  
               next
            end

            next if not inContents

            if ( copyLine.start_with?('/copy')) 
                copyFile = copyLine[6..-1].strip
                @outFile.write "<!-- Begin: #{copyFile} -->\n"
                puts "Including: " + copyFile
                f2 = File.open(copyFile, "r")
                self.readSubFile(f2)
                f2.close         
                @outFile.write "<!-- End: #{copyFile} -->\n"
            else 
                @outFile.write line
            end
        end
    end

end 

app = App.new(ARGV,STDIN)
app.run